import 'package:djorder/features/product/viewmodel/product_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final ProductViewModel productViewModel;

  ProductList({super.key, ProductViewModel? productViewModel})
    : productViewModel = productViewModel ?? getIt<ProductViewModel>();

  @override
  Widget build(BuildContext context) {
    if (productViewModel.isLoading)
      return const Center(child: CircularProgressIndicator());

    if (productViewModel.filteredProducts.isEmpty)
      return const Center(child: Text('Nenhum produto encontrado'));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.separated(
        itemCount: productViewModel.filteredProducts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final product = productViewModel.filteredProducts[i];
          return ListTile(
            title: Text(
              product.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF180E6D),
              ),
            ),
            subtitle: Text('${product.unit} - Cód: ${product.id}'),
            trailing: Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF180E6D),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => productViewModel.selectProduct(product),
          );
        },
      ),
    );
  }
}
