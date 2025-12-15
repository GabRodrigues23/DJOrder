import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:djorder/features/service/settings_service.dart';
import 'package:djorder/features/interfaces/order_repository_interface.dart';
import 'package:djorder/features/model/order.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;
  OrderViewModel(this._repository);
  List<Order> _allOrders = [];
  OrderStatus? currentFilter;
  bool isLoading = false;
  String errorMessage = '';
  Timer? _timer;
  String _searchQuery = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _lastActiveCount = 0;
  bool _isFirstLoad = true;

  List<Order> get orders {
    return _allOrders.where((order) {
      final query = _searchQuery.toUpperCase();
      final bool matchesSearch =
          _searchQuery.isEmpty ||
          order.idOrder.toString().contains(query) ||
          (order.clientName?.toUpperCase().contains(query) ?? false);
      final bool matchesFilter =
          currentFilter == null || order.calculatedStatus == currentFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(OrderStatus? status) {
    currentFilter = status;
    notifyListeners();
  }

  Future<void> loadData() async {
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
}
