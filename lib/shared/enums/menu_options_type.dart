import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';
import 'package:flutter/material.dart';

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
    switch (this) {
      case MenuOption.addProduct:
        return 'Adicionar Produtos';
      case MenuOption.changeClient:
        return (order.clientName == null || order.clientName!.isEmpty)
            ? 'Incluir Cliente'
            : 'Alterar Cliente';
      case MenuOption.changeTable:
        return (order.idTable == null || order.idTable == 0)
            ? 'Incluir Mesa'
            : 'Alterar Mesa';
      case MenuOption.addPeopleNumber:
        return 'Adicionar n° de Pessoas';
      case MenuOption.printOrder:
        return 'Imprimir Pedido';
      case MenuOption.printAccount:
        return 'Conferência de Contas';
      case MenuOption.finalize:
        return 'Finalizar Comanda';
      case MenuOption.block:
        return 'Bloquear Comanda';
      case MenuOption.unblock:
        return 'Desbloquear Comanda';
      case MenuOption.cancel:
        return 'Cancelar Comanda';
    }
  }

  IconData get icon {
    switch (this) {
      case MenuOption.addProduct:
        return Icons.fastfood;
      case MenuOption.changeClient:
        return Icons.person;
      case MenuOption.changeTable:
        return Icons.table_restaurant;
      case MenuOption.addPeopleNumber:
        return Icons.person_add_alt_1;
      case MenuOption.printOrder:
        return Icons.print;
      case MenuOption.printAccount:
        return Icons.receipt_long;
      case MenuOption.finalize:
        return Icons.check_circle_outline;
      case MenuOption.block:
        return Icons.lock_outline;
      case MenuOption.unblock:
        return Icons.lock_open;
      case MenuOption.cancel:
        return Icons.cancel;
    }
  }

  Color? get color {
    switch (this) {
      case MenuOption.finalize:
        return Colors.green[700];
      case MenuOption.block:
        return Colors.orange[700];
      case MenuOption.cancel:
        return Colors.red[700];
      default:
        return Colors.grey[700];
    }
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
