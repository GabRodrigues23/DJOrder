import 'package:flutter/material.dart';

enum MenuOption {
  addProduct('Adicionar Produtos', Icons.fastfood),
  addClient('Incluir Cliente', Icons.person),
  changeClient('Alterar Cliente', Icons.person),
  addTable('Incluir Mesa', Icons.table_restaurant),
  changeTable('Alterar Mesa', Icons.table_restaurant),
  changePeopleCount('Alterar n° de Pessoas', Icons.person_add_alt_1),
  printOrder('Imprimir Pedido', Icons.print),
  printAccount('Conferência de Contas', Icons.receipt_long),
  // finalize(
  //   'Finalizar Pedido',
  //   Icons.check_circle_outline,
  //   color: Color(0xFF388E3C),
  // ),
  block('Bloquear Pedido', Icons.lock_outline, color: Color(0xFFF57C00)),
  unblock('Desbloquear Pedido', Icons.lock_open, color: Color(0xFFF57C00)),
  cancel('Cancelar Pedido', Icons.cancel, color: Color(0xFFD32F2F));

  final String label;
  final IconData icon;
  final Color? color;

  const MenuOption(
    this.label,
    this.icon, {
    this.color = const Color(0xFF616161),
  });
}
