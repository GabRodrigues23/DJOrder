import 'package:flutter/material.dart';

enum ProductOption {
  cancelProduct('Cancelar Produto', Icons.cancel),
  transferProduct('Transferir Produto', Icons.sync_alt);

  final String label;
  final IconData icon;

  const ProductOption(this.label, this.icon);
}
