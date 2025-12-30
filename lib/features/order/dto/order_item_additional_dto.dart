import 'package:djorder/core/utils/dto_utils.dart';
import 'package:djorder/features/order/model/order_additional.dart';

extension OrderItemAdditionalDto on OrderAdditional {
  static OrderAdditional fromJson(Map<String, dynamic> json) {
    return OrderAdditional(
      description: DtoUtils.get<String>(json['DESCRICAO'], defaultValue: ''),
      qtd: DtoUtils.get<double>(json['QTD'], defaultValue: 0),
      price: DtoUtils.get<double>(json['PRECO_UNITARIO'], defaultValue: 0),
    );
  }

  static List<OrderAdditional> fromList(List<dynamic> list) {
    return list.map((i) => OrderItemAdditionalDto.fromJson(i)).toList();
  }
}
