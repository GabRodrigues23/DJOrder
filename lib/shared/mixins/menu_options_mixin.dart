import 'package:djorder/features/order/view/modals/add_product_modal.dart';
import 'package:djorder/features/order/view/modals/block_status_order_modal.dart';
import 'package:djorder/features/order/view/modals/change_people_count_modal.dart';
import 'package:djorder/shared/enums/print_type.dart';
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
        MenuOption.addProduct: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddProductModal(
              idPreSale: order.id,
              visualId: order.idOrder,
              orderViewModel: viewModel,
            ),
          );
        },
        MenuOption.addClient: () async {
          await showDialog(
            context: context,
            builder: (_) => ChangeClientModal(
              order: order,
              viewModel: viewModel,
              option: option,
            ),
          );
        },
        MenuOption.changeClient: () async {
          await showDialog(
            context: context,
            builder: (_) => ChangeClientModal(
              order: order,
              viewModel: viewModel,
              option: option,
            ),
          );
        },
        MenuOption.addTable: () async {
          await showDialog(
            context: context,
            builder: (_) => ChangeTableModal(
              order: order,
              viewModel: viewModel,
              option: option,
            ),
          );
        },
        MenuOption.changeTable: () async {
          await showDialog(
            context: context,
            builder: (_) => ChangeTableModal(
              order: order,
              viewModel: viewModel,
              option: option,
            ),
          );
        },
        MenuOption.changePeopleCount: () async {
          await showDialog(
            context: context,
            builder: (_) =>
                ChangePeopleCountModal(order: order, viewModel: viewModel),
          );
        },
        MenuOption.printOrder: () async {
          await viewModel.print(order, PrintType.order);
        },
        MenuOption.printAccount: () async {
          await viewModel.print(order, PrintType.account);
        },
        MenuOption.finalize: () =>
            debugPrint('Finalizar a comanda #${order.idOrder}'),
        MenuOption.block: () async {
          await showDialog(
            context: context,
            builder: (_) => BlockStatusOrderModal(
              order: order,
              viewModel: viewModel,
              isBlocked: true,
            ),
          );
        },
        MenuOption.unblock: () async {
          await showDialog(
            context: context,
            builder: (_) => BlockStatusOrderModal(
              order: order,
              viewModel: viewModel,
              isBlocked: false,
            ),
          );
        },
        MenuOption.cancel: () async {
          await showDialog(
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
      await viewModel.loadData();
    }
  }
}
