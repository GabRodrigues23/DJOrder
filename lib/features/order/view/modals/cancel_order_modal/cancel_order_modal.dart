import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';

class CancelOrderModal extends StatelessWidget {
  final Order order;
  final OrderViewModel viewModel;

  const CancelOrderModal({
    super.key,
    required this.order,
    required this.viewModel,
  });

  Future<void> _save(BuildContext context) async {
    await viewModel.cancelOrder(order.idOrder, true);

    if (context.mounted && viewModel.errorMessage.isEmpty)
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar o Pedido'),
      content: Text('Deseja confirmar o cancelamento do pedido?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar', style: TextStyle(color: labelCancelColor)),
        ),
        ElevatedButton(
          onPressed: () => _save(context),
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          child: Text('Confirmar', style: TextStyle(color: labelButtonColor)),
        ),
      ],
    );
  }
}
