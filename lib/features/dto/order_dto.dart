import 'package:djorder/core/utils/dto_utils.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_itens.dart';

class OrderDto {
  static Order fromJson(Map<String, dynamic> json) {
    var productsList = DtoUtils.get<List>(json['products'], defaultValue: []);

    return Order(
      id: DtoUtils.get<int>((json['CODPREVENDA']), defaultValue: 0),
      idOrder: DtoUtils.get<int>(json['ID_COMANDA'], defaultValue: 0),
      idTable: DtoUtils.get<int>(json['IDMESA'], defaultValue: 0),
      status: json['COO'],
      clientName: DtoUtils.get<String>(
        json['NOME_CLIENTE'],
        defaultValue: 'Vendas A Vista',
      ),
      subtotal: DtoUtils.get<double>(json['SUBTOTAL'], defaultValue: 0),
      serviceTax: DtoUtils.get<double>(json['TAXA_SERVICO'], defaultValue: 0),
      oppeningDate: DtoUtils.get<DateTime>(
        json['DATAHORA_INICIO'],
        defaultValue: DateTime.now(),
      ),
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
