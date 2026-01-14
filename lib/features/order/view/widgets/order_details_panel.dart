import 'package:djorder/features/order/view/widgets/actions_button_widget.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:djorder/shared/enums/product_options_type.dart';
import 'package:djorder/shared/mixins/menu_options_mixin.dart';
import 'package:djorder/shared/mixins/product_options_mixin.dart';
import 'package:flutter/material.dart';
import 'package:djorder/core/utils/format_utils.dart';
import 'package:djorder/features/order/model/order.dart';

class OrderDetailsPanel extends StatelessWidget
    with MenuOptionsMixin, ProductOptionsMixin {
  final Order? order;
  final OrderViewModel viewModel;

  OrderDetailsPanel({super.key, required this.order, OrderViewModel? viewModel})
    : viewModel = viewModel ?? getIt<OrderViewModel>();

  @override
  Widget build(BuildContext context) {
    if (order == null)
      return const Center(
        child: Text(
          'Selecione uma comanda\npara visualizar os detalhes.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final int peopleCount = order?.peopleCount ?? 1;
        final bool isOrderFree = order!.products.isEmpty;

        if (isOrderFree)
          return Center(
            child: Text(
              'Comanda ${order!.idOrder} está livre, \nadicione produtos para abrir \na comanda',
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
                          return _buildProductItem(context, item);
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

                    _infoRow(
                      "Valor por Pessoa:",
                      "R\$ ${FormatUtils.formatValue((order!.totalValue / peopleCount).toStringAsFixed(2))}",
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
      },
    );
  }

  Widget _buildProductItem(BuildContext context, dynamic item) {
    final isCanceled = item.status == 'S';

    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails details) {
        if (isCanceled) return;
        _showProductMenu(context, details.globalPosition, item);
      },
      onLongPressStart: (LongPressStartDetails details) {
        if (isCanceled) return;
        _showProductMenu(context, details.globalPosition, item);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${item.qtd.toInt()}x ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isCanceled ? TextDecoration.lineThrough : null,
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
                      color: isCanceled ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                Text(
                  "R\$ ${FormatUtils.formatValue(item.price.toStringAsFixed(2))}",
                  style: TextStyle(
                    decoration: isCanceled ? TextDecoration.lineThrough : null,
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
                      .map<Widget>(
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
        ),
      ),
    );
  }

  void _showProductMenu(
    BuildContext context,
    Offset position,
    dynamic item,
  ) async {
    final RelativeRect positionRect = RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    );

    final ProductOption? selected = await showMenu<ProductOption>(
      context: context,
      position: positionRect,
      items: ProductOption.values.map((option) {
        return PopupMenuItem<ProductOption>(
          value: option,
          child: Row(
            children: [
              Icon(option.icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Text(option.label),
            ],
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      handleProductAction(context, selected, order!, item, viewModel);
    }
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
