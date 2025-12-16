class OrderAdditional {
  final String description;
  final double qtd;
  final double price;

  OrderAdditional({
    required this.description,
    required this.qtd,
    required this.price,
  });

  factory OrderAdditional.fromJson(Map<String, dynamic> json) {
    return OrderAdditional(
      description: json['DESC_ADIC'],
      qtd: (json['QTD_ADIC']).toDouble(),
      price: (json['PRECO_ADIC']).toDouble(),
    );
  }
}
