import 'package:flutter/material.dart';
import 'package:djorder/core/utils/format_utils.dart';
import 'package:djorder/features/model/order.dart';

class OrderDetailsPanel extends StatelessWidget {
  final Order? order;

  const OrderDetailsPanel({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
          const Divider(),

          if (order == null)
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${item.qtd.toInt()}x ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: Text(item.description)),
                                Text(
                                  "R\$ ${FormatUtils.formatValue(item.price.toStringAsFixed(2))}",
                                ),
                              ],
                            ),

                            if (item.additional.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  top: 4,
                                ),
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
                                            Text(
                                              "${additional.qtd.toInt()}x ${additional.description}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
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
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
