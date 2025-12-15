import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/repository/order_repository.dart';
import 'package:djorder/features/service/order_service.dart';
import 'package:djorder/features/view/monitor/widgets/order_details_panel.dart';
import 'package:djorder/features/view/monitor/widgets/order_filters_bar.dart';
import 'package:djorder/features/view/monitor/widgets/order_item_widget.dart';
import 'package:djorder/features/viewmodel/order_view_model.dart';

class OrdersMonitorPage extends StatefulWidget {
  const OrdersMonitorPage({super.key});

  @override
  State<OrdersMonitorPage> createState() => _OrdersMonitorPageState();
}

class _OrdersMonitorPageState extends State<OrdersMonitorPage> {
  late final OrderViewModel viewModel;

  Order? selectedOrder;
  int? selectedIdOrder;

  @override
  void initState() {
    super.initState();
    final service = OrderService();
    final repository = OrderRepository(service);
    viewModel = OrderViewModel(repository);

    viewModel.loadData();
    viewModel.startAutoRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.stopAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'DJORDER - Monitor',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF180E6D),
        actions: [
          IconButton(
            onPressed: () => viewModel.loadData(),
            icon: const Icon(Icons.refresh, color: Color(0xFFFFFFFF)),
          ),
          IconButton(
            onPressed: () {
              Modular.to.pushReplacementNamed('/');
            },
            icon: Icon(Icons.keyboard_return, color: Color(0xFFFFFFFF)),
          ),
        ],
      ),

      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          Order? activeOrder;

          if (selectedIdOrder != null && viewModel.orders.isNotEmpty) {
            try {
              activeOrder = viewModel.orders.firstWhere(
                (element) => element.idOrder == selectedIdOrder,
              );
            } catch (e) {
              selectedIdOrder = null;
            }
          }

          return Column(
            children: [
              OrderFiltersBar(
                currentFilter: viewModel.currentFilter,
                onFilterChanged: (newStatus) {
                  viewModel.setFilter(newStatus);
                },
                onSearchChanged: (query) {
                  viewModel.setSearchQuery(query);
                },
              ),

              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildGridSection(activeOrder)),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      flex: 1,
                      child: OrderDetailsPanel(order: activeOrder),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridSection(Order? activeOrder) {
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

    return GridView.builder(
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
                  border: Border.all(color: const Color(0xFF180E6D), width: 3),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: OrderItemWidget(
            order: order,
            onTap: () {
              setState(() {
                selectedIdOrder = order.idOrder;
              });
              debugPrint('Clicou na comanda ${order.idOrder}');
            },
          ),
        );
      },
    );
  }
}
