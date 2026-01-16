import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/view/modals/add_product_modal/widgets/product_additional.dart';
import 'package:djorder/features/order/view/modals/add_product_modal/widgets/product_list.dart';
import 'package:djorder/features/order/view/modals/add_product_modal/widgets/product_qty_button.dart';
import 'package:djorder/features/order/view/modals/add_product_modal/widgets/product_search_field.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/features/product/viewmodel/product_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class AddProductModal extends StatefulWidget {
  final int id;
  final int idOrder;
  final OrderViewModel orderViewModel;

  AddProductModal({
    super.key,
    required this.id,
    required this.idOrder,
    OrderViewModel? orderViewModel,
  }) : orderViewModel = orderViewModel ?? getIt<OrderViewModel>();

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  late final ProductViewModel _addProductViewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    _addProductViewModel = ProductViewModel(getIt<OrderRepositoryInterface>());
    _addProductViewModel.loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmAdd() async {
    final error = _addProductViewModel.validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    await _addProductViewModel.confirmAdd(widget.id, widget.idOrder);
    await widget.orderViewModel.loadData();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _addProductViewModel,
      builder: (context, _) {
        final isProductSelected = _addProductViewModel.selectedProduct != null;

        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.fastfood, color: Color(0xFF180E6D)),
              SizedBox(width: 10),
              Text('Adicionar Pedido'),
            ],
          ),
          content: SizedBox(
            width: 700,
            height: 500,
            child: Column(
              children: [
                if (!isProductSelected)
                  ProductSearchField(
                    controller: _searchController,
                    onChanged: _addProductViewModel.search,
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: isProductSelected
                      ? _buildSelectedProductView()
                      : ProductList(productViewModel: _addProductViewModel),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: labelCancelColor),
              ),
            ),
            if (isProductSelected)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _confirmAdd,
                child: const Text(
                  'ADICIONAR ITEM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedProductView() {
    return Column(
      children: [
        _SelectedProductHeader(productViewModel: _addProductViewModel),

        if (_addProductViewModel
            .selectedProduct!
            .additionalGroups
            .isNotEmpty) ...[
          const SizedBox(height: 10),
          const Divider(),
          const Text(
            'Adicionais:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ProductAdditional(productViewModel: _addProductViewModel),
          ),
        ] else
          const Spacer(),
      ],
    );
  }
}

class _SelectedProductHeader extends StatelessWidget {
  final ProductViewModel productViewModel;
  _SelectedProductHeader({ProductViewModel? productViewModel})
    : productViewModel = productViewModel ?? getIt<ProductViewModel>();

  @override
  Widget build(BuildContext context) {
    final product = productViewModel.selectedProduct;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => productViewModel.clearSelection(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        "Trocar Produto",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  product!.description,
                  style: const TextStyle(
                    color: Color(0xFF180E6D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Total: R\$ ${(product.price * productViewModel.quantity).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ProductQtyButton(
                icon: Icons.remove,
                onPressed: productViewModel.decrementQty,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${productViewModel.quantity.toInt()}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF180E6D),
                  ),
                ),
              ),
              ProductQtyButton(
                icon: Icons.add,
                onPressed: productViewModel.incrementQty,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
