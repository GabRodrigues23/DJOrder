enum PrintType {
  order(label: 'Pedido'),
  account(label: 'Conferência de Conta');

  final String label;
  const PrintType({required this.label});
}
