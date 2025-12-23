import 'package:flutter/material.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';

enum MenuOption {
  addProduct,
  changeClient,
  changeTable,
  addPeopleNumber,
  printOrder,
  printAccount,
  finalize,
  block,
  unblock,
  cancel;

  String getLabel(Order order) {
    final labels = <MenuOption, String>{
      MenuOption.addProduct: 'Adicionar Produtos',
      MenuOption.changeClient:
          (order.clientName == null ||
              order.clientName!.isEmpty ||
              order.clientName! == 'VENDAS AO CONSUMIDOR')
          ? 'Incluir Cliente'
          : 'Alterar Cliente',
      MenuOption.changeTable: (order.idTable == null || order.idTable == 0)
          ? 'Incluir Mesa'
          : 'Alterar Mesa',
      MenuOption.addPeopleNumber: 'Adicionar n° de Pessoas',
      MenuOption.printOrder: 'Imprimir Pedido',
      MenuOption.printAccount: 'Conferência de Contas',
      MenuOption.finalize: 'Finalizar Comanda',
      MenuOption.block: 'Bloquear Comanda',
      MenuOption.unblock: 'Desbloquear Comanda',
      MenuOption.cancel: 'Cancelar Comanda',
    };
    return labels[this] ?? '';
  }

  IconData get icon {
    final icons = <MenuOption, IconData>{
      MenuOption.addProduct: Icons.fastfood,
      MenuOption.changeClient: Icons.person,
      MenuOption.changeTable: Icons.table_restaurant,
      MenuOption.addPeopleNumber: Icons.person_add_alt_1,
      MenuOption.printOrder: Icons.print,
      MenuOption.printAccount: Icons.receipt_long,
      MenuOption.finalize: Icons.check_circle_outline,
      MenuOption.block: Icons.lock_outline,
      MenuOption.unblock: Icons.lock_open,
      MenuOption.cancel: Icons.cancel,
    };
    return icons[this] ?? Icons.error;
  }

  Color? get color {
    final colors = <MenuOption, Color?>{
      MenuOption.finalize: Colors.green[700],
      MenuOption.block: Colors.orange[700],
      MenuOption.cancel: Colors.red[700],
    };
    return colors[this] ?? Colors.grey[700];
  }

  static List<MenuOption> getOptionsFor(Order order) {
    final status = order.calculatedStatus;
    if (status == OrderStatus.free) {
      return [MenuOption.addProduct];
    }

    if (status == OrderStatus.lock) {
      return [MenuOption.unblock];
    }

    return [
      MenuOption.addProduct,
      MenuOption.changeClient,
      MenuOption.changeTable,
      MenuOption.addPeopleNumber,
      MenuOption.printOrder,
      MenuOption.printAccount,
      MenuOption.finalize,
      MenuOption.block,
      MenuOption.cancel,
    ];
  }
}
