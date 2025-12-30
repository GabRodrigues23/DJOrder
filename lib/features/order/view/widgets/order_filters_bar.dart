import 'package:flutter/material.dart';
import 'package:djorder/shared/enums/order_status_type.dart';

class OrderFiltersBar extends StatefulWidget {
  final OrderStatus? currentFilter;
  final Function(OrderStatus?) onFilterChanged;
  final Function(String) onSearchChanged;

  const OrderFiltersBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  State<OrderFiltersBar> createState() => _OrderFiltersBarState();
}

class _OrderFiltersBarState extends State<OrderFiltersBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 400,
            height: 40,
            child: TextField(
              controller: _controller,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                  },
                  icon: Icon(Icons.clear, size: 20, color: Colors.red[300]),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          const SizedBox(width: 20),
          const Text(
            "Filtrar: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(OrderStatus? status, String label, Color color) {
    final isSelected = widget.currentFilter == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => widget.onFilterChanged(status),
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
