import 'package:djorder/features/model/order.dart';

abstract class OrderRepositoryInterface {
  Future<List<Order>> loadAll();
}
