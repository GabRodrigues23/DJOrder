import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:flutter/material.dart';

class OrderFiltersBar extends StatelessWidget {
  final OrderStatus? currentFilter;

  final Function(OrderStatus?) onFilterChanged;

  const OrderFiltersBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            "Filtrar por: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(width: 10),

          _buildChip(null, 'Todos', Colors.blueGrey),
          const SizedBox(width: 8),
          ...OrderStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(status, status.label, status.color),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(OrderStatus? status, String label, Color color) {
    final isSelected = currentFilter == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(status),
      selectedColor: color.withAlpha(2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? color : Colors.grey.shade300),
      ),
      showCheckmark: true,
    );
  }
}
