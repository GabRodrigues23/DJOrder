import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

class ChangeClientModal extends StatefulWidget {
  final Order order;
  final OrderViewModel viewModel;
  final MenuOption option;
  const ChangeClientModal({
    super.key,
    required this.order,
    required this.viewModel,
    required this.option,
  });

  @override
  State<ChangeClientModal> createState() => _ChangeClientModalState();
}

class _ChangeClientModalState extends State<ChangeClientModal> {
  late TextEditingController _clientNameController;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(
      text: widget.order.clientName,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _clientNameController.dispose();
  }

  void _save() async {
    final String newName = _clientNameController.text;
    await widget.viewModel.changeClient(widget.order.id, newName);
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
            controller: _clientNameController,
            autofocus: true,
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
