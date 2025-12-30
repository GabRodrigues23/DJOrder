import 'package:djorder/features/order/view/widgets/actions_button_widget.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/shared/mixins/menu_options_mixin.dart';
import 'package:flutter/material.dart';
import 'package:djorder/core/utils/format_utils.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrderDetailsPanel extends StatelessWidget with MenuOptionsMixin {
  final Order? order;

  const OrderDetailsPanel({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    if (order == null)
      return const Center(
        child: Text(
          'Selecione uma comanda\npara visualizar os detalhes.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Detalhes da Comanda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ActionsButtonWidget(
                order: order!,
                onSelected: (option) =>
                    handleMenuAction(context, option, order!, viewModel),
              ),
            ],
          ),
          const Divider(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "#${order!.idOrder}",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF180E6D),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow("Cliente:", order!.clientName ?? ''),
                if (order!.idTable != null && order!.idTable != 0)
                  _infoRow('Mesa:', '${order!.idTable}'),
                const Divider(height: 30),
                const Text(
                  "Itens do Pedido:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.separated(
                    itemCount: order!.products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = order!.products[index];
                      final isCanceled = item.status == 'S';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${item.qtd.toInt()}x ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: isCanceled
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCanceled ? Colors.red : Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.description,
                                  style: TextStyle(
                                    decoration: isCanceled
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isCanceled
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "R\$ ${FormatUtils.formatValue(item.price.toStringAsFixed(2))}",
                                style: TextStyle(
                                  decoration: isCanceled
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCanceled ? Colors.red : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          if (item.additional.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Column(
                                children: item.additional
                                    .map(
                                      (additional) => Row(
                                        children: [
                                          const Icon(
                                            Icons.subdirectory_arrow_right,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${additional.qtd.toInt()}x ${additional.description}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          if (additional.price > 0)
                                            Text(
                                              " + R\$ ${FormatUtils.formatValue(additional.price.toStringAsFixed(2))}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const Divider(),
                _infoRow(
                  "Subtotal:",
                  "R\$ ${FormatUtils.formatValue(order!.effectiveSubtotal.toStringAsFixed(2))}",
                ),
                _infoRow(
                  "Serviço:",
                  "R\$ ${FormatUtils.formatValue(order!.serviceTax.toStringAsFixed(2))}",
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
                        "R\$ ${FormatUtils.formatValue(order!.totalValue.toStringAsFixed(2))}",
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
          Text(
            label,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.start,
            softWrap: false,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
              softWrap: true,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
