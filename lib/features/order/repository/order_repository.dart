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

  String _peopleKey(int preSaleId) => 'order_presale_${preSaleId}_people';

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
    int idPreSale,
    int visualId,
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
      idPreSale,
      visualId: visualId,
      idProduct: product.id,
      qtd: quantity,
      unitPrice: product.price,
      additionals: additionalsJson,
    );
  }

  @override
  Future<void> changeClient(int idOrder, String newName) async {
    final nameClean = newName.trim();
    if (nameClean.isEmpty) {
      throw Exception("O nome do cliente não pode ser vazio");
    }
    await _service.updateOrder(idOrder, clientName: nameClean);
  }

  @override
  Future<void> changeTable(int idOrder, int? newTable) async {
    await _service.updateOrder(idOrder, tableId: newTable);
  }

  @override
  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  }) async {
    final orderPrefs = await SharedPreferences.getInstance();
    await orderPrefs.setInt(_peopleKey(idPreSales), peopleCount);
  }

  @override
  Future<int> getPeopleCount(int orderId) async {
    final orderPrefs = await SharedPreferences.getInstance();
    return orderPrefs.getInt(_peopleKey(orderId)) ?? 1;
  }

  @override
  Future<void> cancelOrder(int idOrder, bool newCanceledStatus) async {
    await _service.updateOrder(idOrder, isCanceled: newCanceledStatus);
  }

  @override
  Future<void> blockOrder(int idOrder, bool newBlockedStatus) async {
    await _service.updateOrder(idOrder, isBlocked: newBlockedStatus);
  }

  @override
  Future<void> cancelProduct(int idOrder, int seqItem) async {
    await _service.cancelProduct(idOrder, seqItem);
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
