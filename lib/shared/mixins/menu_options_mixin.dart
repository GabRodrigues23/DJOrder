import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

mixin MenuOptionsMixin {
  void handleMenuAction(BuildContext context, MenuOption option, Order order) {
    switch (option) {
      case MenuOption.addProduct:
        debugPrint('Abrir modal de produtos para a comanda #${order.idOrder}');
        break;
      case MenuOption.changeClient:
        debugPrint('Abrir modal de clientes para a comanda #${order.idOrder}');
        break;
      case MenuOption.changeTable:
        debugPrint('Abrir modal de mesa para a comanda #${order.idOrder}');
        break;
      case MenuOption.addPeopleNumber:
        debugPrint(
          'Abrir modal de n° pessoas para a comanda #${order.idOrder}',
        );
        break;
      case MenuOption.printOrder:
        debugPrint('Imprimir pedidos para a comanda #${order.idOrder}');
        break;
      case MenuOption.printAccount:
        debugPrint(
          'Imprimir conferência de contas para a comanda #${order.idOrder}',
        );
        break;
      case MenuOption.finalize:
        debugPrint('Finalizar a comanda #${order.idOrder}');
        break;
      case MenuOption.block:
        debugPrint('Bloquear a comanda #${order.idOrder}');
        break;
      case MenuOption.unblock:
        debugPrint('Desbloquear a comanda #${order.idOrder}');
        break;
      case MenuOption.cancel:
        debugPrint('Cancelar a comanda #${order.idOrder}');
        break;
    }
  }
}
