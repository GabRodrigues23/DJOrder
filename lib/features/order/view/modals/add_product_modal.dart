import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/features/product/viewmodel/product_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class AddProductModal extends StatefulWidget {
  final int idPreSale;
  final int visualId;
  final OrderViewModel orderViewModel;

  const AddProductModal({
    super.key,
    required this.idPreSale,
    required this.visualId,
    required this.orderViewModel,
  });

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  late final ProductViewModel _addProductViewModel;
  final TextEditingController _searchController = TextEditingController();

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
    await _addProductViewModel.confirmAdd(widget.idPreSale, widget.visualId);

    await widget.orderViewModel.loadData();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _addProductViewModel,
      builder: (context, _) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.fastfood, color: Color(0xFF180E6D)),
              const SizedBox(width: 10),
              Text('Adicionar Produto'),
            ],
          ),
          content: SizedBox(
            width: 700,
            height: 500,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nome ou código',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: _addProductViewModel.search,
                  autofocus: true,
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: _addProductViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _addProductViewModel.filteredProducts.isEmpty
                      ? const Center(child: Text('Nenhum produto encontrado'))
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView.separated(
                            itemCount:
                                _addProductViewModel.filteredProducts.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final p =
                                  _addProductViewModel.filteredProducts[i];
                              final isSelected =
                                  _addProductViewModel.selectedProduct?.id ==
                                  p.id;

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor: Colors.blue.withAlpha(1),
                                title: Text(
                                  p.description,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${p.unit} - Cód: ${p.id}'),
                                trailing: Text(
                                  'R\$ ${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () =>
                                    _addProductViewModel.selectProduct(p),
                              );
                            },
                          ),
                        ),
                ),

                if (_addProductViewModel.selectedProduct != null &&
                    _addProductViewModel
                        .selectedProduct!
                        .additionalGroups
                        .isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    "Adicionais:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _addProductViewModel
                          .selectedProduct!
                          .additionalGroups
                          .length,
                      itemBuilder: (ctx, i) {
                        final group = _addProductViewModel
                            .selectedProduct!
                            .additionalGroups[i];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                group.description,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            ...group.items.map((item) {
                              final isSelected = _addProductViewModel
                                  .selectedAdditionals
                                  .contains(item);
                              return CheckboxListTile(
                                title: Text(
                                  item.price > 0
                                      ? '${item.description} + R\$ ${item.price.toStringAsFixed(2).replaceAll('.', ',')}'
                                      : item.description,
                                ),
                                value: isSelected,
                                onChanged: (val) {
                                  _addProductViewModel.toggleAdditional(
                                    group,
                                    item,
                                  );
                                },
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkboxShape: group.max == 1
                                    ? const CircleBorder()
                                    : null,
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                ],

                if (_addProductViewModel.selectedProduct != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _addProductViewModel.selectedProduct!.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Total: R\$ ${(_addProductViewModel.selectedProduct!.price * _addProductViewModel.quantity).toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onPressed: _addProductViewModel.decrementQty,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                '${_addProductViewModel.quantity.toInt()}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onPressed: _addProductViewModel.incrementQty,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: labelButtonCancelColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonConfirmColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                final error = _addProductViewModel.validate();
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error), backgroundColor: Colors.red),
                  );
                  return;
                }
                await _confirmAdd();
              },
              child: Text(
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
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
