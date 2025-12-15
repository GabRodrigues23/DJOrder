import 'package:djorder/features/model/order.dart';
import 'package:djorder/shared/enums/order_status_type.dart';

extension OrderStatusExtension on Order {
  OrderStatus get calculatedStatus {
    if (status != null && status! < 0) return OrderStatus.lock;
    if (products.isNotEmpty) return OrderStatus.busy;
    return OrderStatus.free;
  }
}
