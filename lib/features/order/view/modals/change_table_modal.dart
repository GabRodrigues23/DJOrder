import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

class ChangeTableModal extends StatefulWidget {
  final Order order;
  final OrderViewModel viewModel;
  final MenuOption option;
  const ChangeTableModal({
    super.key,
    required this.order,
    required this.viewModel,
    required this.option,
  });

  @override
  State<ChangeTableModal> createState() => _ChangeTableModalState();
}

class _ChangeTableModalState extends State<ChangeTableModal> {
  late TextEditingController _tableIdController;

  @override
  void initState() {
    super.initState();
    _tableIdController = TextEditingController(
      text: widget.order.idTable.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tableIdController.dispose();
  }

  void _save() async {
    final String text = _tableIdController.text.trim();
    final int? newTable = text.isEmpty ? 0 : int.tryParse(text);

    if (newTable == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Número da mesa inválido')));
      return;
    }

    await widget.viewModel.changeTable(widget.order.idOrder, newTable);

    if (!mounted) return;

    if (widget.viewModel.errorMessage.isEmpty) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.option.label, textAlign: TextAlign.center),
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
            controller: _tableIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'N° da Mesa:',
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
