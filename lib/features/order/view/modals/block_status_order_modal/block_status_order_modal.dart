import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';

class BlockStatusOrderModal extends StatelessWidget {
  final Order order;
  final OrderViewModel viewModel;
  final bool isBlocked;

  const BlockStatusOrderModal({
    super.key,
    required this.order,
    required this.viewModel,
    required this.isBlocked,
  });

  Future<void> _save(BuildContext context) async {
    await viewModel.blockOrder(order.idOrder, isBlocked);
    if (context.mounted && viewModel.errorMessage.isEmpty)
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = isBlocked ? 'Bloquear Pedido' : 'Desbloquear Pedido';
    final content = isBlocked
        ? 'Deseja confirmar o Bloqueio deste Pedido?'
        : 'Deseja confirmar o Desbloqueio deste pedido';
    final buttonLabel = isBlocked ? 'Bloquear' : 'Desbloquear';

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar', style: TextStyle(color: labelCancelColor)),
        ),
        ElevatedButton(
          onPressed: () => _save(context),
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          child: Text(buttonLabel, style: TextStyle(color: labelButtonColor)),
        ),
      ],
    );
  }
}
