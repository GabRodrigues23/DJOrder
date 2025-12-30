import 'package:djorder/features/order/model/order.dart';

abstract class OrderRepositoryInterface {
  Future<List<Order>> loadAll();
}
