import 'package:flutter/material.dart';

class OrderStatusTheme extends ThemeExtension<OrderStatusTheme> {
  final Color freeColor;
  final Color busyColor;
  final Color lockColor;

  const OrderStatusTheme({
    required this.freeColor,
    required this.busyColor,
    required this.lockColor,
  });

  @override
  OrderStatusTheme copyWith({
    Color? freeColor,
    Color? busyColor,
    Color? lockColor,
  }) {
    return OrderStatusTheme(
      freeColor: freeColor ?? this.freeColor,
      busyColor: busyColor ?? this.busyColor,
      lockColor: lockColor ?? this.lockColor,
    );
  }

  @override
  OrderStatusTheme lerp(ThemeExtension<OrderStatusTheme>? other, double t) {
    if (other is! OrderStatusTheme) {
      return this;
    }
    return OrderStatusTheme(
      freeColor: Color.lerp(freeColor, other.freeColor, t)!,
      busyColor: Color.lerp(busyColor, other.busyColor, t)!,
      lockColor: Color.lerp(lockColor, other.lockColor, t)!,
    );
  }
}
