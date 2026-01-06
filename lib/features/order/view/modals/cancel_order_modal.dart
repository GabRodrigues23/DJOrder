import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';

class CancelOrderModal extends StatefulWidget {
  final Order order;
  final OrderViewModel viewModel;

  const CancelOrderModal({
    super.key,
    required this.order,
    required this.viewModel,
  });

  @override
  State<CancelOrderModal> createState() => _CancelOrderModalState();
}

class _CancelOrderModalState extends State<CancelOrderModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _save() async {
    bool isCanceled = true;

    await widget.viewModel.cancelOrder(widget.order.idOrder, isCanceled);

    if (!mounted) return;

    if (widget.viewModel.errorMessage.isEmpty) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar o Pedido'),
      content: Text('Deseja confirmar o cancelamento do pedido?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 5,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Fechar',
                style: TextStyle(color: labelButtonCancelColor),
              ),
            ),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonConfirmColor,
              ),
              child: Text(
                'Confirmar',
                style: TextStyle(color: labelButtonConfirmColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
