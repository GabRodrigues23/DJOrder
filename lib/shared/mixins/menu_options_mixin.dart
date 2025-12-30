import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/view/modals/change_client_modal.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

mixin MenuOptionsMixin {
  void handleMenuAction(
    BuildContext context,
    MenuOption option,
    Order order,
    OrderViewModel viewModel,
  ) {
    viewModel.setPaused(true);
    try {
      final actions = <MenuOption, VoidCallback>{
        MenuOption.addProduct: () => debugPrint(
          'Abrir modal de produtos para a comanda #${order.idOrder}',
        ),
        MenuOption.changeClient: () {
          showDialog(
            context: context,
            builder: (_) =>
                ChangeClientModal(order: order, viewModel: viewModel),
          );
        },
        MenuOption.changeTable: () =>
            debugPrint('Abrir modal de mesa para a comanda #${order.idOrder}'),
        MenuOption.addPeopleNumber: () => debugPrint(
          'Abrir modal de n° pessoas para a comanda #${order.idOrder}',
        ),
        MenuOption.printOrder: () =>
            debugPrint('Imprimir pedidos para a comanda #${order.idOrder}'),
        MenuOption.printAccount: () => debugPrint(
          'Imprimir conferência de contas para a comanda #${order.idOrder}',
        ),
        MenuOption.finalize: () =>
            debugPrint('Finalizar a comanda #${order.idOrder}'),
        MenuOption.block: () =>
            debugPrint('Bloquear a comanda #${order.idOrder}'),
        MenuOption.unblock: () =>
            debugPrint('Desbloquear a comanda #${order.idOrder}'),
        MenuOption.cancel: () =>
            debugPrint('Cancelar a comanda #${order.idOrder}'),
      };
      actions[option]?.call();
    } finally {
      viewModel.setPaused(false);
    }
  }
}
