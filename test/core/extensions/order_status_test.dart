import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_items.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Logica de troca de status das comandas', () {
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

    test('Comanda Livre quando status for cancelado' , () {
      final order = createOrder(canceled: 'S', items: [activeItem]);
      expect(order.calculatedStatus, OrderStatus.free);
    });

    test('Comanda Livre quando coo > 0 (Comanda Fechada)', () {
      final order = createOrder(coo: 123456, items: [activeItem]);
      expect(order.calculatedStatus, OrderStatus.free);
    });

    test('Comanda Bloqueada se coo < 0', () {
      final order = createOrder(coo: -1);
      expect(order.calculatedStatus, OrderStatus.lock);
    });

    test(
      'Comanda bloqueada se houver produtos e coo 0 ou coo nulo',
      () {
        final order = createOrder(coo: 0, items: [activeItem]);
        expect(order.calculatedStatus, OrderStatus.busy);
      },
    );
  });
}
