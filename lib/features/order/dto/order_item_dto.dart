import 'package:djorder/core/utils/dto_utils.dart';
import 'package:djorder/features/order/dto/order_item_additional_dto.dart';
import 'package:djorder/features/order/model/order_item.dart';

extension OrderItemDto on OrderItem {
  static OrderItem fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: DtoUtils.get<int>(json['CODPRODUTO'], defaultValue: 0),
      sequence: DtoUtils.get<int>(json['SEQUENCIA'], defaultValue: 0),
      description: DtoUtils.get<String>(json['DESCRICAO'], defaultValue: ''),
      qtd: DtoUtils.get<double>(json['QTD'], defaultValue: 0),
      price: DtoUtils.get<double>(json['PRECO_UNITARIO'], defaultValue: 0),
      status: DtoUtils.get<String>(json['CANCELADO'], defaultValue: 'N'),
      additional: OrderItemAdditionalDto.fromList(
        DtoUtils.get<List>(json['additional'], defaultValue: []),
      ),
    );
  }

  static List<OrderItem> fromList(List<dynamic> list) {
    return list.map((i) => OrderItemDto.fromJson(i)).toList();
  }
}
