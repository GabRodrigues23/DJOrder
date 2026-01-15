import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';

abstract class OrderRepositoryInterface {
  Future<List<Order>> loadAll();

  Future<List<Product>> getCatalog();
  Future<void> includeProduct(
    int idPreSale,
    int visualId,
    Product product,
    double quantity, [
    List<AdditionalItem>? additionals,
  ]);

  Future<void> changeClient(int id, String clientName);
  Future<void> changeTable(int id, int tableId);

  Future<int> getPeopleCount(int idOrder);
  Future<void> updatePeopleCount({required int id, required int peopleCount});

  Future<void> cancelOrder(int id, bool canceledStatus);
  Future<void> blockOrder(int id, bool blockedStatus);

  Future<void> cancelProduct(int id, int seqItem);
  Future<void> transferProduct(int id, int seqItem, int targetOrderId);
}
