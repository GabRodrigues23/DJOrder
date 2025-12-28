import 'package:djorder/features/view/monitor/widgets/order_grid_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/repository/order_repository.dart';
import 'package:djorder/features/service/order_service.dart';
import 'package:djorder/features/view/monitor/widgets/order_details_panel.dart';
import 'package:djorder/features/view/monitor/widgets/order_filters_bar.dart';
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

  void _handleOrderSelection(int idOrder) {
    setState(() {
      selectedIdOrder = idOrder;
    });
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
                  if (query.isEmpty) viewModel.clearSearchQuery();
                  viewModel.setSearchQuery(query);
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: OrderGridPanel(
                        viewModel: viewModel,
                        activeOrder: activeOrder,
                        onOrderSelected: _handleOrderSelection,
                      ),
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
}
