import 'dart:async';

import 'package:djorder/features/interfaces/order_repository_interface.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/order_status_extension.dart';
import 'package:flutter/material.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;
  OrderViewModel(this._repository);

  List<Order> _allOrders = [];
  OrderStatus? currentFilter;

  bool isLoading = false;
  String errorMessage = '';

  List<Order> get orders {
    if (currentFilter == null) {
      return _allOrders;
    }

    return _allOrders.where((order) {
      return order.calculatedStatus == currentFilter;
    }).toList();
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

      List<Order> tempList = [];

      for (int i = 1; i <= 100; i++) {
        final existingOrder = activeOrders.firstWhere(
          (order) => order.idOrder == i,
          orElse: () => Order.empty(i),
        );
        tempList.add(existingOrder);
      }
      _allOrders = tempList;
    } catch (e) {
      errorMessage = 'Erro ao buscar dados';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Timer? _timer;

  void startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      loadData();
      debugPrint('Atualizando dados automaticamente...');
    });
  }

  void stopAutoRefresh() {
    _timer?.cancel();
  }
}
