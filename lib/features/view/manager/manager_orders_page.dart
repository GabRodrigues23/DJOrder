import 'package:flutter/material.dart';
import 'package:djorder/features/repository/order_repository.dart';
import 'package:djorder/features/service/order_service.dart';
import 'package:djorder/features/viewmodel/order_view_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManagerOrdersPage extends StatefulWidget {
  const ManagerOrdersPage({super.key});

  @override
  State<ManagerOrdersPage> createState() => _ManagerOrdersPageState();
}

class _ManagerOrdersPageState extends State<ManagerOrdersPage> {
  late final OrderViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final service = OrderService();
    final repository = OrderRepository(service);
    viewModel = OrderViewModel(repository);
    viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DJORDER',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF180E6D),
        actions: [
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
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          }
          if (viewModel.orders.isEmpty) {
            return const Center(child: Text('Nenhuma comanda disponível'));
          }

          return ListView.builder(
            itemCount: viewModel.orders.length,
            itemBuilder: (context, index) {
              final order = viewModel.orders[index];
              return ListTile(
                title: Text('#${order.idOrder}'),
                subtitle: Text('${order.clientName}'),
                trailing: Text(
                  'Total: R\$ ${order.totalValue.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
