import 'package:djorder/features/order/model/order_additional.dart';

class OrderItem {
  final int id;
  final int sequence;
  final String description;
  final double qtd;
  final double price;
  final String? status;
  final List<OrderAdditional> additional;

  OrderItem({
    required this.id,
    required this.sequence,
    required this.description,
    required this.qtd,
    required this.price,
    this.status,
    this.additional = const [],
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    var additionalList = json['additional'] as List? ?? [];
    return OrderItem(
      id: json['CODPRODUTO'],
      sequence: json['SEQUENCIA'],
      description: json['DESCRICAO'],
      qtd: (json['QTD']).toDouble(),
      price: (json['PRECO_UNITARIO']).toDouble(),
      status: json['CANCELADO'] ?? 'N',
      additional: additionalList
          .map((i) => OrderAdditional.fromJson(i))
          .toList(),
    );
  }
}
