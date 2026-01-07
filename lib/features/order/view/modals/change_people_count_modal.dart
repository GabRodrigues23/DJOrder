import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:flutter/material.dart';

class ChangePeopleCountModal extends StatefulWidget {
  final Order order;
  final OrderViewModel viewModel;
  const ChangePeopleCountModal({
    super.key,
    required this.order,
    required this.viewModel,
  });

  @override
  State<ChangePeopleCountModal> createState() => _ChangePeopleCountModalState();
}

class _ChangePeopleCountModalState extends State<ChangePeopleCountModal> {
  late TextEditingController _peopleCountController;

  @override
  void initState() {
    super.initState();
    final p = widget.order;
    _peopleCountController = TextEditingController(
      text: p.peopleCount.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _peopleCountController.dispose();
  }

  void _save() async {
    final String text = _peopleCountController.text.trim();
    final int parsed = int.tryParse(text) ?? 1;
    final int newPeopleCount = parsed < 1 ? 1 : parsed;

    await widget.viewModel.changePeopleCount(widget.order.id, newPeopleCount);

    if (!mounted) return;

    if (widget.viewModel.errorMessage.isEmpty) Navigator.pop(context);

    debugPrint('numero de pessoas na mesa : $newPeopleCount');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        MenuOption.changePeopleCount.getLabel(widget.order),
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
            controller: _peopleCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'N° de Pessoas:',
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
