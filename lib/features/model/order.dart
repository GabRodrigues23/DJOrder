import 'package:djorder/features/model/order_items.dart';

class Order {
  final int id;
  final int idOrder;
  final int? idTable;
  final int? status;
  final String canceled;
  final String? clientName;
  final double subtotal;
  final double serviceTax;
  final DateTime oppeningDate;
  final List<OrderItems> products;

  Order({
    required this.id,
    required this.idOrder,
    this.idTable,
    this.status,
    required this.canceled,
    this.clientName,
    required this.subtotal,
    required this.serviceTax,
    required this.oppeningDate,
    required this.products,
  });

  factory Order.empty(int orderId) {
    return Order(
      id: 0,
      idOrder: orderId,
      status: null,
      canceled: 'N',
      clientName: null,
      subtotal: 0.0,
      serviceTax: 0.0,
      oppeningDate: DateTime.now(),
      products: [],
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;
    return Order(
      id: json['CODPREVENDA'],
      idOrder: json['ID_COMANDA'],
      idTable: json['IDMESA'],
      status: json['COO'],
      canceled: json['STATUS_PEDIDO'],
      clientName: json['NOME_CLIENTE'],
      subtotal: (json['SUBTOTAL']).toDouble(),
      serviceTax: (json['TAXA_SERVICO']).toDouble(),
      oppeningDate:
          DateTime.tryParse(json['DATAHORA_INICIO'] ?? '') ?? DateTime.now(),
      products: productsList.map((i) => OrderItems.fromJson(i)).toList(),
    );
  }

  double get totalAdditional {
    double total = 0.0;
    for (var item in products) {
      for (var additional in item.additional) {
        total += (additional.price * additional.qtd);
      }
    }
    return total;
  }

  double get effectiveSubtotal => subtotal + totalAdditional;
  double get totalValue => effectiveSubtotal + serviceTax;
}
