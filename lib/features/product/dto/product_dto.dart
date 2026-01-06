import 'package:djorder/core/utils/dto_utils.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';

class ProductDto {
  static Product fromJson(Map<String, dynamic> json) {
    var groupsJson = json['additional_groups'] as List? ?? [];
    List<AdditionalGroup> groups = groupsJson
        .map((g) => AdditionalGroup.fromJson(g))
        .toList();

    return Product(
      id: DtoUtils.get<int>(json['CODPRODUTO'], defaultValue: 0),
      barcode: DtoUtils.get<String>(
        json['CODBARRAS'],
        defaultValue: json['CODPRODUTO'].toString(),
      ),
      description: DtoUtils.get<String>(
        json['DESCRICAO'],
        defaultValue: 'SEM DESCRICAO',
      ),
      price: DtoUtils.get<double>(
        (json['PRECO_VENDA'] as num?)?.toDouble(),
        defaultValue: 0,
      ),
      unit: DtoUtils.get<String>(json['UN'], defaultValue: 'UN'),
      flag: DtoUtils.get<int>(json['FLAG'], defaultValue: 0),
      additionalGroups: groups,
    );
  }
}
