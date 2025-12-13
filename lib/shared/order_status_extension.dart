import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/order_theme_extension.dart';
import 'package:flutter/material.dart';

enum OrderStatus { free, busy, lock }

// enum OrderStatus {
//   free(Color(0xFFFF4545)),
//   busy(Color(0xFFFF4545)),
//   lock(Color(0xFFFF4545));

//   final Color color;
//   const OrderStatus(this.color);

// }

extension OrderStatusExtension on Order {
  OrderStatus get calculatedStatus {
    if (status != null && status! < 0) return OrderStatus.lock;
    if (products.isNotEmpty) return OrderStatus.busy;
    return OrderStatus.free;
  }
}

extension OrderStatusColorHelper on OrderStatus {
  Color getColor(BuildContext context) {
    final theme = Theme.of(context).extension<OrderStatusTheme>();

    if (theme == null) return Colors.black;

    switch (this) {
      case OrderStatus.free:
        return theme.freeColor;
      case OrderStatus.busy:
        return theme.busyColor;
      case OrderStatus.lock:
        return theme.lockColor;
    }
  }
}
