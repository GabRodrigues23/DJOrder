import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';

extension OrderStatusExtension on Order {
  OrderStatus get calculatedStatus {
    if (canceled == 'S') return OrderStatus.free;
    if (status != null && status! > 0) return OrderStatus.free;
    if (status != null && status! < 0) return OrderStatus.lock;
    final activeProducts = products.where((p) => p.status != 'S').toList();
    if (activeProducts.isNotEmpty) return OrderStatus.busy;
    return OrderStatus.free;
  }
}
