import 'package:djorder/features/product/model/additional.dart';

class Product {
  final int id;
  final String barcode;
  final String description;
  final double price;
  final String unit;
  final int flag;
  final List<AdditionalGroup> additionalGroups;

  Product({
    required this.id,
    required this.barcode,
    required this.description,
    required this.price,
    required this.unit,
    required this.flag,
    required this.additionalGroups,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['CODPRODUTO'] ?? 0,
      barcode: json['CODBARRAS'] ?? json['CODPRODUTO'],
      description: json['DESCRICAO'],
      price: json['PRECO_VENDA'].toDouble(),
      unit: json['UN'] ?? 'UN',
      flag: json['FLAG'] ?? 0,
      additionalGroups: json['additional_groups'],
    );
  }
}
