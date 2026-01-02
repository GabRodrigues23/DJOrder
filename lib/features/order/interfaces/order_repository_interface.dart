import 'package:djorder/features/order/model/order.dart';

abstract class OrderRepositoryInterface {
  Future<List<Order>> loadAll();
  Future<void> changeClient(int idOrder, String newName);
  Future<void> changeTable(int idOrder, int newTable);
  Future<void> cancelOrder(int idOrder, bool newCanceledStatus);
}
