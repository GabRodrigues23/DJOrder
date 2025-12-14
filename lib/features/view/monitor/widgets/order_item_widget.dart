import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/order_status_extension.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderItemWidget({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = order.calculatedStatus;

    final bool showDetails = status != OrderStatus.free;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: status.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 4),
              color: Colors.black26,
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.idOrder}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              if (showDetails) ...[
                Text(
                  '${order.clientName}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],

              if (showDetails) ...[
                if (order.idTable != null && order.idTable != 0)
                  Text(
                    'Mesa: ${order.idTable}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                else
                  Text(
                    '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
              ],

              if (showDetails)
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'R\$ ${order.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
