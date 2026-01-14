import 'package:flutter/material.dart';

enum ProductOption {
  cancelProduct('Cancelar Produto', Icons.cancel, Color(0xFFFF4545)),
  transferProduct(
    'Transferir Produto',
    Icons.sync_alt,
    Color.fromARGB(255, 6, 110, 142),
  );

  final String label;
  final IconData icon;
  final Color? color;

  const ProductOption(this.label, this.icon, this.color);
}
