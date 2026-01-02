import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;
  OrderViewModel(this._repository);

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

      List<Order> tempList = [];
      for (int i = 1; i <= 100; i++) {
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

  Future<void> changeClient(int idOrder, String newName) async {
    try {
      await _repository.changeClient(idOrder, newName);
      await loadData();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (changeClient): $e');
      notifyListeners();
    }
  }

  Future<void> changeTable(int idOrder, int? newTable) async {
    try {
      await _repository.changeTable(idOrder, newTable!);
      await loadData();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (changeTable): $e');
      notifyListeners();
    }
  }

  Future<void> cancelOrder(int idOrder, bool newCanceledStatus) async {
    try {
      await _repository.cancelOrder(idOrder, newCanceledStatus);
      await loadData();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Erro no ViewModel (cancelOrder): $e');
      notifyListeners();
    }
  }
}
