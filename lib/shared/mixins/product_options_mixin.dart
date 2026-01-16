import 'dart:async';

import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/model/order_item.dart';
import 'package:djorder/features/order/view/modals/cancel_product_modal/cancel_product_modal.dart';
import 'package:djorder/features/order/view/modals/transfer_product_modal/transfer_product_modal.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/product_options_type.dart';
import 'package:flutter/material.dart';

mixin ProductOptionsMixin {
  Future<void> handleProductAction(
    BuildContext context,
    ProductOption option,
    Order order,
    OrderItem productItem,
    OrderViewModel viewModel,
  ) async {
    viewModel.setPaused(true);
    try {
      final actions = <ProductOption, FutureOr<void> Function()>{
        ProductOption.cancelProduct: () async {
          await showDialog(
            context: context,
            builder: (context) => CancelProductModal(
              order: order,
              item: productItem,
              viewModel: viewModel,
            ),
          );
        },
        ProductOption.transferProduct: () async {
          await showDialog(
            context: context,
            builder: (context) => TransferProductModal(
              order: order,
              item: productItem,
              viewModel: viewModel,
            ),
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
