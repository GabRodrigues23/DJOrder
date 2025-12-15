import 'package:djorder/features/model/order_additional.dart';

class OrderItens {
  final int id;
  final String description;
  final double qtd;
  final double price;
  final String? status;
  final List<OrderAdditional> additional;

  OrderItens({
    required this.id,
    required this.description,
    required this.qtd,
    required this.price,
    this.status,
    this.additional = const [],
  });

  factory OrderItens.fromJson(Map<String, dynamic> json) {
    var additionalList = json['additional'] as List? ?? [];
    return OrderItens(
      id: json['CODPRODUTO'],
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
