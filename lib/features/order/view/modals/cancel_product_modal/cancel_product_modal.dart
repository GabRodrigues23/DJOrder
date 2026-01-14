import 'package:djorder/core/constants/colors.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/model/order_item.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';

class CancelProductModal extends StatelessWidget {
  final Order order;
  final OrderItem item;
  final OrderViewModel viewModel;

  CancelProductModal({
    super.key,
    required this.order,
    required this.item,
    OrderViewModel? viewModel,
  }) : viewModel = viewModel ?? getIt<OrderViewModel>();

  Future<void> _save(BuildContext context) async {
    await viewModel.cancelProductAndCheckOrder(order.id, item.sequence);

    if (context.mounted && viewModel.errorMessage.isEmpty)
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancelar Produto'),
      content: Text(
        'Deseja confirmar o cancelamento do produto?\n${item.description}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar', style: TextStyle(color: labelCancelColor)),
        ),

        ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            if (viewModel.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return ElevatedButton(
              onPressed: () => _save(context),
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              child: Text(
                'Confirmar',
                style: TextStyle(color: labelButtonColor),
              ),
            );
          },
        ),
      ],
    );
  }
}
