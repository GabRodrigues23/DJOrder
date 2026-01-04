import 'package:djorder/features/order/view/modals/change_people_count_modal.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/view/modals/cancel_order_modal.dart';
import 'package:djorder/features/order/view/modals/change_client_modal.dart';
import 'package:djorder/features/order/view/modals/change_table_modal.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';

mixin MenuOptionsMixin {
  Future<void> handleMenuAction(
    BuildContext context,
    MenuOption option,
    Order order,
    OrderViewModel viewModel,
  ) async {
    viewModel.setPaused(true);
    try {
      final actions = <MenuOption, FutureOr<void> Function()>{
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
        MenuOption.changeTable: () {
          showDialog(
            context: context,
            builder: (_) =>
                ChangeTableModal(order: order, viewModel: viewModel),
          );
        },
        MenuOption.changePeopleCount: () {
          showDialog(
            context: context,
            builder: (_) =>
                ChangePeopleCountModal(order: order, viewModel: viewModel),
          );
        },
        MenuOption.printOrder: () async {
          await viewModel.printOrder(order);
        },
        MenuOption.printAccount: () async {
          await viewModel.printAccount(order);
        },
        MenuOption.finalize: () =>
            debugPrint('Finalizar a comanda #${order.idOrder}'),
        MenuOption.block: () =>
            debugPrint('Bloquear a comanda #${order.idOrder}'),
        MenuOption.unblock: () =>
            debugPrint('Desbloquear a comanda #${order.idOrder}'),
        MenuOption.cancel: () {
          showDialog(
            context: context,
            builder: (_) =>
                CancelOrderModal(order: order, viewModel: viewModel),
          );
        },
      };
      final action = actions[option];
      if (action != null) {
        await action();
      }
    } finally {
      viewModel.setPaused(false);
    }
  }
}
