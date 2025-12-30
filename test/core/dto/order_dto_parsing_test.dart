import 'package:djorder/features/order/dto/order_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Conversão JSON de OrderDTO', () {
    test(
      'Conversão de uma data válida em formato ISO 8601 do servidor Lazarus',
      () {
        final json = {
          'CODPREVENDA': 1,
          'ID_COMANDA': 50,
          'COO': 0,
          'NOME_CLIENTE': 'Cliente Teste',
          'SUBTOTAL': 100.0,
          'TAXA_SERVICO': 10.0,
          'DATAHORA_INICIO': '2025-12-15T21:30:00',
          'STATUS_PEDIDO': 'N',
          'products': [],
        };

        final order = OrderDto.fromJson(json);

        expect(order.oppeningDate.year, 2025);
        expect(order.oppeningDate.month, 12);
        expect(order.oppeningDate.hour, 21);
        expect(order.oppeningDate.minute, 30);
      },
    );

    test('Retorno de DateTime.now() se a data for NULL ou inválida', () {
      final json = {
        'CODPREVENDA': 1,
        'ID_COMANDA': 50,
        'SUBTOTAL': 0,
        'TAXA_SERVICO': 0,
        'DATAHORA_INICIO': null,
        'STATUS_PEDIDO': 'N',
        'products': [],
      };

      final order = OrderDto.fromJson(json);

      expect(order.oppeningDate, isNotNull);
      expect(DateTime.now().difference(order.oppeningDate).inSeconds < 5, true);
    });

    test('Mapear STATUS_PEDIDO para um campo cancelado', () {
      final jsonCanceled = {
        'CODPREVENDA': 1,
        'ID_COMANDA': 1,
        'SUBTOTAL': 0,
        'TAXA_SERVICO': 0,
        'STATUS_PEDIDO': 'S',
        'products': [],
      };

      final order = OrderDto.fromJson(jsonCanceled);
      expect(order.canceled, 'S');
    });
  });
}
