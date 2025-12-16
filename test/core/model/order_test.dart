import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_additional.dart';
import 'package:djorder/features/model/order_itens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Calculos', () {
    OrderItens createItem(
      double price, {
      List<OrderAdditional> additional = const [],
    }) {
      return OrderItens(
        id: 1,
        description: 'Item Teste',
        qtd: 1,
        price: price,
        status: 'N',
        additional: additional,
      );
    }

    test(
      'totalAdditional deve somar o valor de todos os itens adicionais corretamente',
      () {
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
        debugPrint('TotalAdditional: ${order.totalAdditional}');
      },
    );

    test(
      'effectiveSubtotal deve somar o valor de Subtotal + valor do Total de Adicionais',
      () {
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
        debugPrint('EffectiveSubtotal: ${order.effectiveSubtotal}');
      },
    );

    test(
      'totalValue deve somar o valor do Total do Subtotal + o valor da Taxa de Serviço',
      () {
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
        debugPrint('TotalValue: ${order.totalValue}');
      },
    );
  });
}
