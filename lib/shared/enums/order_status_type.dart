import 'package:flutter/material.dart';

enum OrderStatus {
  free(Color(0xFF6BC57E), 'Livre'),
  busy(Color(0xFFFFDC6B), 'Ocupada'),
  lock(Color(0xFFFF4545), 'Bloqueada');

  final Color color;
  final String label;

  const OrderStatus(this.color, this.label);
}
