import 'package:flutter/material.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/interfaces/order_repository_interface.dart';
import 'package:djorder/features/service/order_service.dart';
import 'package:djorder/features/dto/order_dto.dart';

class OrderRepository implements OrderRepositoryInterface {
  final OrderService _service;
  OrderRepository(this._service);

  @override
  Future<List<Order>> loadAll() async {
    try {
      final data = await _service.loadAll();
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erro no repository: $e');
      rethrow;
    }
  }
}
