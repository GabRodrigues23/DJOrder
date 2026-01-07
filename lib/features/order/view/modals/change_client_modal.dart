import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

class ChangeClientModal extends StatefulWidget {
  final Order order;
  final OrderViewModel viewModel;
  const ChangeClientModal({
    super.key,
    required this.order,
    required this.viewModel,
  });

  @override
  State<ChangeClientModal> createState() => _ChangeClientModalState();
}

class _ChangeClientModalState extends State<ChangeClientModal> {
  late TextEditingController _clientNameController;

  @override
  void initState() {
    super.initState();
    final p = widget.order;
    _clientNameController = TextEditingController(text: p.clientName);
  }

  @override
  void dispose() {
    super.dispose();
    _clientNameController.dispose();
  }

  void _save() async {
    final String newName = _clientNameController.text;
    await widget.viewModel.changeClient(widget.order.idOrder, newName);
    if (!mounted) return;

    if (widget.viewModel.errorMessage.isEmpty) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        MenuOption.changeClient.getLabel(widget.order),
        textAlign: TextAlign.center,
      ),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Comanda: #${widget.order.idOrder}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _clientNameController,
            decoration: const InputDecoration(
              labelText: 'Nome do Cliente:',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
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
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: buttonConfirmColor),
          child: Text(
            'Salvar',
            style: TextStyle(color: labelButtonConfirmColor),
          ),
        ),
      ],
    );
  }
}
