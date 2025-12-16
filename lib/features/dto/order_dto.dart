import 'package:djorder/features/dto/order_item_dto.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/core/utils/dto_utils.dart';

class OrderDto {
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: DtoUtils.get<int>((json['CODPREVENDA']), defaultValue: 0),
      idOrder: DtoUtils.get<int>(json['ID_COMANDA'], defaultValue: 0),
      idTable: DtoUtils.get<int>(json['IDMESA'], defaultValue: 0),
      status: json['COO'],
      canceled: DtoUtils.get<String>(json['STATUS_PEDIDO'], defaultValue: 'N'),
      clientName: DtoUtils.get<String>(
        json['NOME_CLIENTE'],
        defaultValue: 'Vendas A Vista',
      ),
      subtotal: DtoUtils.get<double>(json['SUBTOTAL'], defaultValue: 0),
      serviceTax: DtoUtils.get<double>(json['TAXA_SERVICO'], defaultValue: 0),
      oppeningDate:
          DateTime.tryParse(json['DATAHORA_INICIO']?.toString() ?? '') ??
          DateTime.now(),
      products: OrderItemDto.fromList(
        DtoUtils.get<List>(json['products'], defaultValue: []),
      ),
    );
  }
}
