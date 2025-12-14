class OrderAddons {
  final String description;
  final double qtd;
  final double price;

  OrderAddons({
    required this.description,
    required this.qtd,
    required this.price,
  });

  factory OrderAddons.fromJson(Map<String, dynamic> json) {
    return OrderAddons(
      description: json['DESC_ADIC'],
      qtd: (json['QTD_ADIC']).toDouble(),
      price: (json['PRECO_ADIC']).toDouble(),
    );
  }
}
