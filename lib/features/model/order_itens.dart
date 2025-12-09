class OrderItens {
  final int id;
  final String description;
  final double qtd;
  final double price;
  final String? status;
  // final List<OrderItensAdic> adicProduct;

  OrderItens({
    required this.id,
    required this.description,
    required this.qtd,
    required this.price,
    this.status,
  });

  factory OrderItens.fromJson(Map<String, dynamic> json) {
    return OrderItens(
      id: json['CODPRODUTO'],
      description: json['DESCRICAO'],
      qtd: (json['QTD']).toDouble(),
      price: (json['PRECO_UNITARIO']).toDouble(),
      status: json['CANCELADO'] ?? 'N',
    );
  }
}
