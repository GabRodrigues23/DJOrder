import 'package:djorder/core/utils/dto_utils.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/model/order_addons.dart';
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
    var addonsList = DtoUtils.get<List>(json['addons'], defaultValue: []);
    return OrderItens(
      id: DtoUtils.get<int>(json['CODPRODUTO'], defaultValue: 0),
      description: DtoUtils.get<String>(json['DESCRICAO'], defaultValue: ''),
      qtd: DtoUtils.get<double>(json['QTD'], defaultValue: 0),
      price: DtoUtils.get<double>(json['PRECO_UNITARIO'], defaultValue: 0),
      status: DtoUtils.get<String>(json['CANCELADO'], defaultValue: 'N'),
      addons: addonsList.map((a) => _addonFromJson(a)).toList(),
    );
  }

  static OrderAddons _addonFromJson(Map<String, dynamic> json) {
    return OrderAddons(
      description: DtoUtils.get<String>(json['DESCRICAO'], defaultValue: ''),
      qtd: DtoUtils.get<double>(json['QTD_'], defaultValue: 0),
      price: DtoUtils.get<double>(json['PRECO_UNITARIO'], defaultValue: 0),
    );
  }
}
