import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/model/order_additional.dart';
import 'package:djorder/features/order/model/order_items.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Calculos Order', () {
    OrderItems createItem(
      double price, {
      List<OrderAdditional> additional = const [],
    }) {
      return OrderItems(
        id: 1,
        description: 'Item Teste',
        qtd: 1,
        price: price,
        status: 'N',
        additional: additional,
      );
    }

    test('Soma do preço dos adicionais dos produtos (totalAdditional)', () {
      final additional1 = OrderAdditional(
        description: 'Bacon',
        qtd: 1,
        price: 5,
      );
      final additional2 = OrderAdditional(
        description: 'Queijo',
        qtd: 2,
        price: 2.50,
      );

      final item = createItem(20.00, additional: [additional1, additional2]);

      final order = Order(
        id: 1,
        idOrder: 1,
        status: 0,
        subtotal: 20.00,
        serviceTax: 0,
        oppeningDate: DateTime.now(),
        products: [item],
        canceled: 'N',
      );

      expect(order.totalAdditional, 10.00);
    });

    test('Soma dos preço total dos adicionais ao preço dos produtos', () {
      final additional = OrderAdditional(
        description: 'Extra',
        qtd: 1,
        price: 10.00,
      );
      final item = createItem(50.00, additional: [additional]);
      final order = Order(
        id: 1,
        idOrder: 1,
        status: 0,
        subtotal: 50.00,
        serviceTax: 0,
        oppeningDate: DateTime.now(),
        products: [item],
        canceled: 'N',
      );

      expect(order.effectiveSubtotal, 60.00);
    });

    test('Soma do subtotal do produto ao valor de taxa de serviço', () {
      final order = Order(
        id: 1,
        idOrder: 1,
        status: 0,
        subtotal: 100.00,
        serviceTax: 10.00,
        oppeningDate: DateTime.now(),
        products: [],
        canceled: 'N',
      );

      expect(order.totalValue, 110.00);
    });
  });
}
