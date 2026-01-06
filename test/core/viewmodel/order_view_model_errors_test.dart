import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeOrderRepository implements OrderRepositoryInterface {
  bool shouldThrowError = false;
  List<Order> mockList = [];

  @override
  Future<List<Order>> loadAll() async {
    if (shouldThrowError) {
      throw Exception('Falha na conexão com o servidor');
    }
    return mockList;
  }

  @override
  Future<void> cancelOrder(int idOrder, bool newCanceledStatus) {
    throw UnimplementedError();
  }

  @override
  Future<void> changeClient(int idOrder, String newName) {
    throw UnimplementedError();
  }

  @override
  Future<void> changeTable(int idOrder, int newTable) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getCatalog() {
    throw UnimplementedError();
  }

  @override
  Future<int> getPeopleCount(int idOrder) {
    throw UnimplementedError();
  }

  @override
  Future<void> includeProduct(
    int idPreSale,
    int visualId,
    Product product,
    double quantity, [
    List<AdditionalItem>? additionals,
  ]) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late OrderViewModel viewModel;
  late FakeOrderRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeOrderRepository();
    viewModel = OrderViewModel(fakeRepository);
  });

  group('Mensagens de Erro', () {
    test('Erro de conexão com servidor', () async {
      fakeRepository.shouldThrowError = true;
      await viewModel.loadData();

      expect(viewModel.errorMessage, contains('Erro ao buscar dados'));
    });
  });
}
