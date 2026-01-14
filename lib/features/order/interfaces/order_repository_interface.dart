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

  Future<void> changeClient(int idOrder, String newName);
  Future<void> changeTable(int idOrder, int newTable);

  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  });
  Future<int> getPeopleCount(int idOrder);

  Future<void> cancelOrder(int idOrder, bool newCanceledStatus);
  Future<void> blockOrder(int idOrder, bool newBlockedStatus);

  Future<void> cancelProduct(int idOrder, int seqItem);
  Future<void> transferProduct(int idOrder, int seqItem, int targetOrderId);
}
