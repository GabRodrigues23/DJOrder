import 'package:djorder/features/order/model/order.dart';

abstract class OrderRepositoryInterface {
  Future<List<Order>> loadAll();
  Future<void> changeClient(int idOrder, String newName);
  Future<void> changeTable(int idOrder, int newTable);

  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  });
  Future<int> getPeopleCount(int idOrder);

  Future<void> cancelOrder(int idOrder, bool newCanceledStatus);
}
