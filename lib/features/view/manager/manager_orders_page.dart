import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/repository/order_repository.dart';
import 'package:djorder/features/service/order_service.dart';
import 'package:djorder/features/view/manager/widgets/order_item_widget.dart';
import 'package:djorder/features/viewmodel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManagerOrdersPage extends StatefulWidget {
  const ManagerOrdersPage({super.key});

  @override
  State<ManagerOrdersPage> createState() => _ManagerOrdersPageState();
}

class _ManagerOrdersPageState extends State<ManagerOrdersPage> {
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
          return Row(
            children: [
              Expanded(flex: 3, child: _buildGridSection(activeOrder)),
              const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
              Expanded(flex: 1, child: _buildPreviewSection(activeOrder)),
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

  Widget _buildPreviewSection(Order? orderToShow) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Detalhes da Comanda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Divider(color: Color(0xFF180E6D)),

          if (orderToShow == null)
            const Expanded(
              child: Center(
                child: Text(
                  'Selecione uma comanda\npara visualizar os detalhes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "#${orderToShow.idOrder}",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF180E6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoRow(
                    "Cliente:",
                    orderToShow.clientName ?? "Não identificado",
                  ),
                  if (orderToShow.idTable != null && orderToShow.idTable != 0)
                    _infoRow("Mesa:", '${orderToShow.idTable}'),

                  const Divider(height: 30, color: Color(0xFF180E6D)),

                  const Text(
                    "Itens do Pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.separated(
                      itemCount: orderToShow.products.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = orderToShow.products[index];
                        return Row(
                          children: [
                            Text(
                              "${item.qtd.toInt()}x ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(child: Text(item.description)),
                            Text("R\$ ${item.price.toStringAsFixed(2)}"),
                          ],
                        );
                      },
                    ),
                  ),

                  const Divider(color: Color(0xFF180E6D)),

                  _infoRow(
                    "Subtotal:",
                    "R\$ ${orderToShow.subtotal.toStringAsFixed(2)}",
                  ),
                  _infoRow(
                    "Serviço:",
                    "R\$ ${orderToShow.serviceTax.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF180E6D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "TOTAL",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "R\$ ${(orderToShow.subtotal + orderToShow.serviceTax).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
