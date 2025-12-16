import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/view/monitor/widgets/order_item_widget.dart';
import 'package:djorder/features/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';

class OrderGridPanel extends StatelessWidget {
  final OrderViewModel viewModel;
  final Order? activeOrder;
  final void Function(int idOrder) onOrderSelected;

  const OrderGridPanel({
    super.key,
    required this.viewModel,
    this.activeOrder,
    required this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            Text(viewModel.errorMessage),
            ElevatedButton(
              onPressed: viewModel.loadData,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Colors.grey),
          right: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.85,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: viewModel.orders.length,
        itemBuilder: (context, index) {
          final order = viewModel.orders[index];
          final isSelected = activeOrder?.idOrder == order.idOrder;

          return Container(
            decoration: isSelected
                ? BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF180E6D),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: OrderItemWidget(
              order: order,
              onTap: () {
                onOrderSelected(order.idOrder);
                debugPrint('Clicou na comanda ${order.idOrder}');
              },
            ),
          );
        },
      ),
    );
  }
}
