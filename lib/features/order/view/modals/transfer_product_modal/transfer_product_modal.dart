import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/model/order_item.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class TransferProductModal extends StatefulWidget {
  final Order order;
  final OrderItem item;
  final OrderViewModel viewModel;
  TransferProductModal({
    super.key,
    required this.order,
    required this.item,
    OrderViewModel? viewModel,
  }) : viewModel = viewModel ?? getIt<OrderViewModel>();

  @override
  State<TransferProductModal> createState() => _TransferProductModalState();
}

class _TransferProductModalState extends State<TransferProductModal> {
  final TextEditingController _transferProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _transferProductController.dispose();
  }

  void _save() async {
    final String targetText = _transferProductController.text.trim();
    if (targetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o número da comanda de destino.'),
        ),
      );
      return;
    }

    final int? targetVisualId = int.tryParse(targetText);
    if (targetVisualId == null) return;

    await widget.viewModel.transferProduct(
      widget.order.id,
      widget.item.sequence,
      targetVisualId,
    );

    if (mounted && widget.viewModel.errorMessage.isEmpty)
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Transferir Produto', textAlign: TextAlign.center),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Comanda: #${widget.order.idOrder}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: labelButtonColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _transferProductController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Número da Comanda:',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: labelCancelColor)),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          child: Text('Salvar', style: TextStyle(color: labelButtonColor)),
        ),
      ],
    );
  }
}
