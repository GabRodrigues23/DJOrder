import 'dart:async';

import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/model/order_items.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/product_options_type.dart';
import 'package:flutter/material.dart';

mixin ProductOptionsMixin {
  Future<void> handleProductAction(
    BuildContext context,
    ProductOption option,
    Order order,
    OrderItems productItem,
    OrderViewModel viewModel,
  ) async {
    viewModel.setPaused(true);
    try {
      final actions = <ProductOption, FutureOr<void> Function()>{
        ProductOption.cancelProduct: () async {
          debugPrint('Cancelando Produto ID: ${productItem.id}');
        },
        ProductOption.transferProduct: () async {
          debugPrint('Transferindo Produto ID: ${productItem.id}');
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
