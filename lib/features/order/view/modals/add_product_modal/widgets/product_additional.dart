import 'package:djorder/features/product/viewmodel/product_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class ProductAdditional extends StatelessWidget {
  final ProductViewModel productViewModel;

  ProductAdditional({super.key, ProductViewModel? productViewModel})
    : productViewModel = productViewModel ?? getIt<ProductViewModel>();

  @override
  Widget build(BuildContext context) {
    if (productViewModel.selectedProduct == null) return const SizedBox();

    return ListView.builder(
      itemCount: productViewModel.selectedProduct!.additionalGroups.length,
      itemBuilder: (context, i) {
        final group = productViewModel.selectedProduct!.additionalGroups[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8),
              child: Text(
                group.description,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...group.items.map((item) {
              final isSelected = productViewModel.selectedAdditionals.contains(
                item,
              );
              return CheckboxListTile(
                title: Text(
                  item.price > 0
                      ? '${item.description} + R\$ ${item.price.toStringAsFixed(2).replaceAll('.', ',')}'
                      : item.description,
                ),
                value: isSelected,
                onChanged: (val) {
                  productViewModel.toggleAdditional(group, item);
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                checkboxShape: group.max == 1 ? const CircleBorder() : null,
              );
            }),
          ],
        );
      },
    );
  }
}
