import 'package:djorder/features/order/view/widgets/order_grid_panel.dart';
import 'package:flutter/material.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/view/widgets/order_details_panel.dart';
import 'package:djorder/features/order/view/widgets/order_filters_bar.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:go_router/go_router.dart';

class OrdersMonitorPage extends StatefulWidget {
  final OrderViewModel viewModel;

  const OrdersMonitorPage({super.key, required this.viewModel});

  @override
  State<OrdersMonitorPage> createState() => _OrdersMonitorPageState();
}

class _OrdersMonitorPageState extends State<OrdersMonitorPage> {
  Order? selectedOrder;
  int? selectedIdOrder;

  @override
  void initState() {
    super.initState();

    widget.viewModel.loadData();
    widget.viewModel.startAutoRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.stopAutoRefresh();
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
            onPressed: () => widget.viewModel.loadData(),
            icon: const Icon(Icons.refresh, color: Color(0xFFFFFFFF)),
          ),
          IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: Icon(Icons.keyboard_return, color: Color(0xFFFFFFFF)),
          ),
        ],
      ),

      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          Order? activeOrder;

          if (selectedIdOrder != null && widget.viewModel.orders.isNotEmpty) {
            try {
              activeOrder = widget.viewModel.orders.firstWhere(
                (element) => element.idOrder == selectedIdOrder,
              );
            } catch (e) {
              selectedIdOrder = null;
            }
          }

          return Column(
            children: [
              OrderFiltersBar(
                currentFilter: widget.viewModel.currentFilter,
                onFilterChanged: (newStatus) {
                  widget.viewModel.setFilter(newStatus);
                },
                onSearchChanged: (query) {
                  if (query.isEmpty) widget.viewModel.clearSearchQuery();
                  widget.viewModel.setSearchQuery(query);
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: OrderGridPanel(
                        viewModel: widget.viewModel,
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
