import 'dart:async';
import 'package:djorder/features/order/addon/print_account_layout.dart';
import 'package:djorder/features/order/addon/print_order_layout.dart';
import 'package:djorder/shared/enums/print_type.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;
  final SettingsService _settingsService;
  OrderViewModel(this._repository, this._settingsService);

  final PrintOrderLayout _printOrderService = PrintOrderLayout();
  final PrintAccountLayout _printAccountService = PrintAccountLayout();
  late final Map<PrintType, Future<void> Function(Order)> _printMethods = {
    PrintType.order: _printOrderService.generateAndPrintOrder,
    PrintType.account: _printAccountService.generateAndPrintAccount,
  };

  List<Order> _allOrders = [];
  OrderStatus? currentFilter;
  int _lastActiveCount = 0;
  bool isLoading = false;
  bool _isPaused = false;
  bool _isFirstLoad = true;
  Timer? _timer;
  String _searchQuery = '';
  String errorMessage = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Order> get orders {
    return _allOrders.where((order) {
      if (currentFilter != null && order.calculatedStatus != currentFilter) {
        return false;
      }

      final query = _searchQuery.toUpperCase().trim();

      if (query.isEmpty) {
        return true;
      }

      if (query.startsWith('MESA')) {
        final tableNumber = query.replaceFirst('MESA', '').trim();
        return tableNumber.isNotEmpty &&
            order.idTable.toString() == tableNumber;
      }

      if (int.tryParse(query) != null) {
        return order.idOrder.toString() == query;
      }

      return order.clientName?.toUpperCase().contains(query) ?? false;
    }).toList();
  }

  void startAutoRefresh() {
    _timer?.cancel();

    final interval = SettingsService().refreshInterval;
    debugPrint('Iniciando AutoRefresh com intervalo de $interval segundos');

    _timer = Timer.periodic(Duration(seconds: interval), (timer) {
      loadData();
      debugPrint('Atualizando dados automaticamente...');
    });
  }

  void stopAutoRefresh() {
    _timer?.cancel();
    debugPrint('Parando AutoRefresh...');
  }

  void setPaused(bool value) {
    _isPaused = value;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  void setFilter(OrderStatus? status) {
    currentFilter = status;
    notifyListeners();
  }

  void _checkAndPlaySound(int currentCount) async {
    if (!SettingsService().isSoundEnabled) return;

    if (_isFirstLoad) {
      _lastActiveCount = currentCount;
      return;
    }

    if (currentCount > _lastActiveCount) {
      try {
        await _audioPlayer.play(AssetSource('sounds/alert.mp3'));
      } catch (e) {
        debugPrint('Erro ao tocar som: $e');
      }
    }
    _lastActiveCount = currentCount;
  }

  Future<void> loadData() async {
    if (_isPaused) return;

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final activeOrders = await _repository.loadAll();
      _checkAndPlaySound(activeOrders.length);
      final limit = _settingsService.orderLength;

      List<Order> tempList = [];
      for (int i = 1; i <= limit; i++) {
        final existingOrder = activeOrders.firstWhere(
          (order) => order.idOrder == i,
          orElse: () => Order.empty(i),
        );
        tempList.add(existingOrder);
      }
      _allOrders = tempList;
      _isFirstLoad = false;
    } catch (e) {
      errorMessage = 'Erro ao buscar dados';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeClient(int id, String newName) async {
    try {
      await _repository.changeClient(id, newName);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (changeClient): $e');
      notifyListeners();
    }
  }

  Future<void> changeTable(int id, int? newTable) async {
    try {
      await _repository.changeTable(id, newTable!);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (changeTable): $e');
      notifyListeners();
    }
  }

  Future<void> changePeopleCount(int id, int newPeopleCount) async {
    await _repository.updatePeopleCount(id: id, peopleCount: newPeopleCount);

    _allOrders = orders.map((order) {
      if (order.id == id) {
        return order.copyWith(peopleCount: newPeopleCount);
      }
      return order;
    }).toList();
    notifyListeners();
  }

  Future<void> cancelOrder(int id, bool newCanceledStatus) async {
    try {
      await _repository.cancelOrder(id, newCanceledStatus);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (cancelOrder): $e');
      notifyListeners();
    }
  }

  Future<void> blockOrder(int id, bool newBlockedStatus) async {
    try {
      await _repository.blockOrder(id, newBlockedStatus);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (blockOrder): $e');
      notifyListeners();
    }
  }

  Future<void> print(Order order, PrintType type) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      if (order.id == 0 && order.products.isEmpty) {
        throw Exception('Esta comanda está vazia no sistema.');
      }

      final action = _printMethods[type];
      if (action == null) {
        throw Exception('Erro na impressão, tipo de impressão inválida');
      }

      await action(order);
    } catch (e) {
      errorMessage = 'Falha ao imprimir ${type.label}: ${e.toString()}';
      debugPrint('Erro no ViewModel (print ${type.name}): $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkAndCloseIfEmpty(int id) async {
    final activeOrders = await _repository.loadAll();
    final updateOrder = activeOrders.firstWhere(
      (o) => o.id == id,
      orElse: () => Order.empty(0),
    );

    if (updateOrder.id != 0) {
      final hasActiveItems = updateOrder.products.any((p) => p.status != 'S');

      if (!hasActiveItems) {
        await _repository.cancelOrder(id, true);
      }
    }
  }

  Future<void> cancelProduct(int id, int productSequence) async {
    _isPaused = true;
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _repository.cancelProduct(id, productSequence);
      await _checkAndCloseIfEmpty(id);
      await loadData();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      _isPaused = false;
      notifyListeners();
    }
  }

  Future<void> transferProduct(
    int id,
    int productSequence,
    int targetOrderVisualId,
  ) async {
    _isPaused = true;
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _repository.transferProduct(
        id,
        productSequence,
        targetOrderVisualId,
      );
      await _checkAndCloseIfEmpty(id);
      await loadData();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      _isPaused = false;
      notifyListeners();
    }
  }
}
