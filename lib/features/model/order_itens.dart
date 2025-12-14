import 'package:djorder/features/model/order_addons.dart';

class OrderItens {
  final int id;
  final String description;
  final double qtd;
  final double price;
  final String? status;
  final List<OrderAddons> addons;

  OrderItens({
    required this.id,
    required this.description,
    required this.qtd,
    required this.price,
    this.status,
    this.addons = const [],
  });

  factory OrderItens.fromJson(Map<String, dynamic> json) {
    var addonsList = json['addons'] as List? ?? [];
    return OrderItens(
      id: json['CODPRODUTO'],
      description: json['DESCRICAO'],
      qtd: (json['QTD']).toDouble(),
      price: (json['PRECO_UNITARIO']).toDouble(),
      status: json['CANCELADO'] ?? 'N',
      addons: addonsList.map((i) => OrderAddons.fromJson(i)).toList(),
    );
  }
}
