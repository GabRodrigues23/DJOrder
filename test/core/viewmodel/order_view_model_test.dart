import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeOrderRepository implements OrderRepositoryInterface {
  bool shouldThrowError = false;
  List<Order> mockList = [];
  bool wasCancelCalled = false;
  int? lastTableChanged;

  @override
  Future<List<Order>> loadAll() async {
    if (shouldThrowError) throw Exception('Falha na conexão com o servidor');
    return mockList;
  }

  @override
  Future<void> changeClient(int idOrder, String newName) async {
    throw UnimplementedError();
  }

  @override
  Future<void> changeTable(int idOrder, int newTable) async {
    lastTableChanged = newTable;
  }

  @override
  Future<int> getPeopleCount(int idOrder) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelOrder(int idOrder, bool newCanceledStatus) async {
    wasCancelCalled = true;
  }

  @override
  Future<void> blockOrder(int idOrder, bool newBlockedStatus) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getCatalog() {
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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OrderViewModel viewModel;
  late FakeOrderRepository fakeRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'isSoundEnabled': false,
      'refreshInterval': 5,
    });

    await SettingsService().init();

    const channels = ['xyz.luan/audioplayers', 'xyz.luan/audioplayers.global'];
    for (var channelName in channels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannel(channelName),
            (_) async => null,
          );
    }

    fakeRepository = FakeOrderRepository();
    viewModel = OrderViewModel(fakeRepository);
  });

  group('Filtros e Busca por ID da Comanda, Nome do Cliente e ID da Mesa', () {
    test('Deve filtrar pedidos pelo ID da Comanda', () async {
      fakeRepository.mockList = [
        Order(
          id: 1,
          idOrder: 1,
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
        Order(
          id: 2,
          idOrder: 2,
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
      ];
      await viewModel.loadData();
      viewModel.setSearchQuery('1');

      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
    });

    test('Deve filtrar pedidos pelo Nome do Cliente', () async {
      fakeRepository.mockList = [
        Order(
          id: 1,
          idOrder: 1,
          clientName: 'GABRIEL',
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
        Order(
          id: 2,
          idOrder: 2,
          clientName: 'THALES',
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
      ];
      await viewModel.loadData();
      viewModel.setSearchQuery('gabriel'.toUpperCase());

      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
    });

    test('Deve filtrar pedidos pelo ID da Mesa', () async {
      fakeRepository.mockList = [
        Order(
          id: 1,
          idOrder: 1,
          idTable: 10,
          canceled: 'N',
          subtotal: 5.00,
          serviceTax: 0,
          oppeningDate: DateTime.now(),
          products: [],
        ),
        Order(
          id: 2,
          idOrder: 2,
          idTable: 5,
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0,
          oppeningDate: DateTime.now(),
          products: [],
        ),
        Order(
          id: 3,
          idOrder: 3,
          idTable: 10,
          canceled: 'N',
          subtotal: 5.00,
          serviceTax: 0,
          oppeningDate: DateTime.now(),
          products: [],
        ),
      ];
      await viewModel.loadData();
      viewModel.setSearchQuery('MESA 10');

      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
      expect(viewModel.orders.any((o) => o.idOrder == 3), isTrue);
    });
  });

  group('Ações de Edição e Status', () async {
    test('changeClient deve chamar o repositório', () async {
      Order(
        id: 1,
        idOrder: 1,
        clientName: 'Gabriel',
        canceled: 'N',
        subtotal: 10.00,
        serviceTax: 0.00,
        oppeningDate: DateTime.now(),
        products: [],
      );

      await viewModel.changeClient(1, 'Novo Cliente');

      expect(viewModel.orders.any((o) => o.idOrder == 1), 'Novo Cliente');
    });
  });

  group('Teste de Estado', () async {
    fakeRepository.shouldThrowError = true;
    await viewModel.loadData();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, contains('Erro ao buscar dados'));
  });
}
