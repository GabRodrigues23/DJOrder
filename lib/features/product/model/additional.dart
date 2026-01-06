class AdditionalItem {
  final int id;
  final String description;
  final double price;

  AdditionalItem({
    required this.id,
    required this.description,
    required this.price,
  });

  factory AdditionalItem.fromJson(Map<String, dynamic> json) {
    return AdditionalItem(
      id: json['ID_ADICIONAL'] ?? 0,
      description: json['DESCRICAO'],
      price:
          (json['PRECO_ADICIONAL'] as num?)?.toDouble() ??
          (json['PRECO_UNITARIO'] as num?)?.toDouble() ??
          0.0,
    );
  }
}

class AdditionalGroup {
  final int id;
  final String description;
  final int min;
  final int max;
  final List<AdditionalItem> items;

  AdditionalGroup({
    required this.id,
    required this.description,
    required this.min,
    required this.max,
    required this.items,
  });

  factory AdditionalGroup.fromJson(Map<String, dynamic> json) {
    var list = json['additional_items'] as List? ?? [];
    List<AdditionalItem> itemsList = list
        .map((i) => AdditionalItem.fromJson(i))
        .toList();

    return AdditionalGroup(
      id: json['ID_GRUPO_ADICIONAL'],
      description: json['DESCRICAO'],
      min: json['QTD_MINIMA'],
      max: json['QTD_MAXIMA'],
      items: itemsList,
    );
  }
}
