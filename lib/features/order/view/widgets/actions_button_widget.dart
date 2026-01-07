import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:djorder/shared/extensions/menu_options_extension.dart';
import 'package:flutter/material.dart';

class ActionsButtonWidget extends StatelessWidget {
  final Order order;
  final Function(MenuOption) onSelected;

  const ActionsButtonWidget({
    super.key,
    required this.order,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final availableOptions = MenuOptionsExtension.getOptionsFor(order);

    if (availableOptions.isEmpty) return const SizedBox();

    return PopupMenuButton<MenuOption>(
      tooltip: 'Menu de Ações',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) {
        return availableOptions.map((option) {
          return PopupMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(option.icon, size: 20, color: option.color),
                const SizedBox(width: 12),
                Text(
                  option.label,
                  style: TextStyle(
                    color: option.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
