import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_itens.dart';

class OrderDto {
  static Order fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;

    return Order(
      id: json['CODPREVENDA'],
      idOrder: json['ID_COMANDA'],
      idTable: json['IDMESA'],
      status: json['STATUS_PEDIDO'] ?? '',
      clientName: json['NOME_CLIENTE'] ?? 'Vendas A Vista',
      subtotal: (json['SUBTOTAL'] ?? 0).toDouble(),
      serviceTax: (json['TAXA_SERVICO'] ?? 0).toDouble(),
      oppeningDate:
          DateTime.tryParse(json['DATAHORA_INICIO'] ?? '') ?? DateTime.now(),
      products: productsList.map((i) => _itemFromJson(i)).toList(),
    );
  }

  static OrderItens _itemFromJson(Map<String, dynamic> json) {
    return OrderItens(
      id: json['CODPRODUTO'],
      description: json['DESCRICAO'] ?? '',
      qtd: (json['QTD'] ?? 0).toDouble(),
      price: (json['PRECO_UNITARIO'] ?? 0).toDouble(),
      status: json['CANCELADO'] ?? 'N',
    );
  }
}
