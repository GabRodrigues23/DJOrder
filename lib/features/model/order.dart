import 'package:djorder/features/model/order_itens.dart';

class Order {
  final int id;
  final int idOrder;
  final int? idTable;
  final String status;
  final String? clientName;
  final double subtotal;
  final double serviceTax;
  final DateTime oppeningDate;
  final List<OrderItens> products;

  Order({
    required this.id,
    required this.idOrder,
    this.idTable,
    required this.status,
    this.clientName,
    required this.subtotal,
    required this.serviceTax,
    required this.oppeningDate,
    required this.products,
  });

  double get totalValue => subtotal + serviceTax;

  factory Order.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;
    return Order(
      id: json['CODPREVENDA'],
      idOrder: json['ID_COMANDA'],
      idTable: json['IDMESA'],
      status: json['STATUS_PEDIDO'],
      clientName: json['NOME_CLIENTE'],
      subtotal: (json['SUBTOTAL']).toDouble(),
      serviceTax: (json['TAXA_SERVICO']).toDouble(),
      oppeningDate:
          DateTime.tryParse(json['DATAHORA_INICIO'] ?? '') ?? DateTime.now(),
      products: productsList.map((i) => OrderItens.fromJson(i)).toList(),
    );
  }
}
