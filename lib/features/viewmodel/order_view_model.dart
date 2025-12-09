import 'package:djorder/features/interfaces/order_repository_interface.dart';
import 'package:djorder/features/model/order.dart';
import 'package:flutter/material.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;

  OrderViewModel(this._repository);

  List<Order> orders = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      orders = await _repository.loadAll();
    } catch (e) {
      errorMessage = 'Erro ao buscar dados';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
