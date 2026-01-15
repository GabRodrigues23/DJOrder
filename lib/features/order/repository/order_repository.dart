import 'package:djorder/features/product/model/additional.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/dto/order_dto.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/service/order_service.dart';
import 'package:djorder/features/product/model/product.dart';
import 'package:djorder/features/product/dto/product_dto.dart';

class OrderRepository implements OrderRepositoryInterface {
  final OrderService _service;
  OrderRepository(this._service);

  String _peopleKey(int id) => 'order_presale_${id}_people';

  @override
  Future<List<Order>> loadAll() async {
    try {
      final orderPrefs = await SharedPreferences.getInstance();
      final data = await _service.loadAll();
      return data.map((json) {
        final order = OrderDto.fromJson(json);

        bool isFree =
            (order.status == 0 || order.status == null) &&
            order.products.isEmpty;

        if (isFree) {
          orderPrefs.remove(_peopleKey(order.id));
          return order.copyWith(peopleCount: 1);
        } else {
          final peopleCount = orderPrefs.getInt(_peopleKey(order.id)) ?? 1;
          return order.copyWith(peopleCount: peopleCount);
        }
      }).toList();
    } catch (e) {
      debugPrint('Erro no repository: $e');
      rethrow;
    }
  }

  @override
  Future<List<Product>> getCatalog() async {
    final data = await _service.loadProducts();
    return data.map((json) => ProductDto.fromJson(json)).toList();
  }

  @override
  Future<void> includeProduct(
    int id,
    int idOrder,
    Product product,
    double quantity, [
    List<AdditionalItem>? additionals,
  ]) async {
    final additionalsJson = additionals
        ?.map(
          (e) => {'id': e.id, 'description': e.description, 'price': e.price},
        )
        .toList();

    await _service.addProduct(
      id,
      idOrder: idOrder,
      idProduct: product.id,
      qtd: quantity,
      unitPrice: product.price,
      additionals: additionalsJson,
    );
  }

  @override
  Future<void> changeClient(int ids, String clientName) async {
    final nameClean = clientName.trim();
    if (nameClean.isEmpty) {
      throw Exception("O nome do cliente não pode ser vazio");
    }
    await _service.updateOrder(ids, clientName: nameClean);
  }

  @override
  Future<void> changeTable(int ids, int? tableId) async {
    await _service.updateOrder(ids, tableId: tableId);
  }

  @override
  Future<void> updatePeopleCount({
    required int id,
    required int peopleCount,
  }) async {
    final orderPrefs = await SharedPreferences.getInstance();
    await orderPrefs.setInt(_peopleKey(id), peopleCount);
  }

  @override
  Future<int> getPeopleCount(int id) async {
    final orderPrefs = await SharedPreferences.getInstance();
    return orderPrefs.getInt(_peopleKey(id)) ?? 1;
  }

  @override
  Future<void> cancelOrder(int ids, bool canceledStatus) async {
    await _service.updateOrder(ids, isCanceled: canceledStatus);
  }

  @override
  Future<void> blockOrder(int ids, bool blockedStatus) async {
    await _service.updateOrder(ids, isBlocked: blockedStatus);
  }

  @override
  Future<void> cancelProduct(int ids, int seqItem) async {
    await _service.cancelProduct(ids, seqItem);
  }

  @override
  Future<void> transferProduct(
    int idOrder,
    int seqItem,
    int targetOrderId,
  ) async {
    await _service.transferProduct(idOrder, seqItem, targetOrderId);
  }
}
