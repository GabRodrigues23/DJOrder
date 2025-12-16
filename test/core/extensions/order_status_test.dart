import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_items.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Logica de OrderStatus', () {
    Order createOrder({
      String canceled = 'N',
      int? coo,
      List<OrderItems> items = const [],
    }) {
      return Order(
        id: 1,
        idOrder: 10,
        status: coo,
        subtotal: 0,
        serviceTax: 0,
        oppeningDate: DateTime.now(),
        products: items,
        canceled: canceled,
      );
    }

    final activeItem = OrderItems(
      id: 1,
      description: 'X',
      qtd: 1,
      price: 10,
      status: 'N',
      additional: [],
    );

    test('Deve ser FREE se canceled = "S"', () {
      final order = createOrder(canceled: 'S', items: [activeItem]);
      expect(order.calculatedStatus, OrderStatus.free);
      debugPrint('OrderStatus: ${order.calculatedStatus}');
    });

    test('Deve ser FREE se COO > 0 (Venda Finalizada/Cancelada)', () {
      final order = createOrder(coo: 123456, items: [activeItem]);
      expect(order.calculatedStatus, OrderStatus.free);
      debugPrint('OrderStatus: ${order.calculatedStatus}');
    });

    test('Deve ser LOCKED se COO < 0', () {
      final order = createOrder(coo: -1);
      expect(order.calculatedStatus, OrderStatus.lock);
      debugPrint('OrderStatus: ${order.calculatedStatus}');
    });

    test(
      'Deve ser BUSY se for uma abertura de comanda normal (COO = 0 ou NULL) com produtos',
      () {
        final order = createOrder(coo: 0, items: [activeItem]);
        expect(order.calculatedStatus, OrderStatus.busy);
        debugPrint('OrderStatus: ${order.calculatedStatus}');
      },
    );
  });
}
