import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:djorder/shared/enums/print_type.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeOrderRepository implements OrderRepositoryInterface {
  bool shouldThrowError = false;
  List<Order> mockList = [];
  String? newClientName;
  int? newPeopleCount;
  int? newTableChanged;
  bool wasCanceled = false;
  bool wasBlocked = false;

  @override
  Future<List<Order>> loadAll() async {
    if (shouldThrowError) throw Exception('Falha na conexão com o servidor');
    return mockList;
  }

  @override
  Future<void> changeClient(int idOrder, String newName) async {
    newClientName = newName;
  }

  @override
  Future<void> changeTable(int idOrder, int newTable) async {
    newTableChanged = newTable;
  }

  @override
  Future<int> getPeopleCount(int idOrder) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePeopleCount({
    required int idPreSales,
    required int peopleCount,
  }) async {
    newPeopleCount = peopleCount;
  }

  @override
  Future<void> cancelOrder(int idOrder, bool newCanceledStatus) async {
    wasCanceled = newCanceledStatus;
  }

  @override
  Future<void> blockOrder(int idOrder, bool newBlockedStatus) async {
    wasBlocked = newBlockedStatus;
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
    setUp(() {
      fakeRepository.mockList = [
        Order(
          id: 1,
          idOrder: 1,
          idTable: 10,
          peopleCount: 1,
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
          idTable: 5,
          peopleCount: 2,
          clientName: 'THALES',
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
      ];
    });

    test('Deve filtrar pedidos pelo ID da Comanda', () async {
      await viewModel.loadData();
      viewModel.setSearchQuery('1');
      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
    });

    test('Deve filtrar pedidos pelo Nome do Cliente', () async {
      await viewModel.loadData();
      viewModel.setSearchQuery('gabriel'.toUpperCase());
      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
    });

    test('Deve filtrar pedidos pelo ID da Mesa', () async {
      await viewModel.loadData();
      viewModel.setSearchQuery('MESA 10');
      expect(viewModel.orders.any((o) => o.idOrder == 1), isTrue);
      expect(viewModel.orders.any((o) => o.idOrder == 2), isFalse);
    });
  });

  group('Ações de Edição e Status', () {
    test('changeClient deve atualizar o nome do cliente', () async {
      await viewModel.changeClient(1, 'Novo Cliente');
      expect(fakeRepository.newClientName, equals('Novo Cliente'));
    });

    test('changeTable deve atualizar a mesa', () async {
      await viewModel.changeTable(1, 2);
      expect(fakeRepository.newTableChanged, equals(2));
    });

    test('changePeopleCount deve atualizar a quantidade de pessoas', () async {
      fakeRepository.mockList = [
        Order(
          id: 1,
          idOrder: 1,
          peopleCount: 1,
          canceled: 'N',
          subtotal: 10.00,
          serviceTax: 0.00,
          oppeningDate: DateTime.now(),
          products: [],
        ),
      ];
      await viewModel.loadData();
      await viewModel.changePeopleCount(1, 3);
      expect(fakeRepository.newPeopleCount, equals(3));
    });

    test('blockOrder deve atualizar o status da comanda', () async {
      await viewModel.blockOrder(1, true);
      expect(fakeRepository.wasBlocked, isTrue);
    });

    test('cancelOrder deve cancelar a comanda', () async {
      await viewModel.cancelOrder(1, true);
      expect(fakeRepository.wasCanceled, isTrue);
    });
  });

  group('Teste de Estado', () {
    test('Deve carregar 100 posições de comandas', () async {
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
      ];
      await viewModel.loadData();
      expect(viewModel.orders.length, equals(100));
    });

    test('setPaused deve impedir loadData', () async {
      viewModel.setPaused(true);
      await viewModel.loadData();
      expect(viewModel.isLoading, isFalse);
    });

    test(
      'Deve exibir mensagem de erro quando não houver comunicação',
      () async {
        fakeRepository.shouldThrowError = true;
        await viewModel.loadData();
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, contains('Erro ao buscar dados'));
      },
    );

    test(
      'Imprimir pedido deve retornar erro se a comanda estiver vazia',
      () async {
        final emptyOrder = Order.empty(1);
        await viewModel.print(emptyOrder, PrintType.order);
        expect(
          viewModel.errorMessage,
          contains('Esta comanda está vazia no sistema.'),
        );
      },
    );

    test(
      'Imprimir conferência de contas deve retornar erro se a comanda estiver vazia',
      () async {
        final emptyOrder = Order.empty(1);
        await viewModel.print(emptyOrder, PrintType.account);
        expect(
          viewModel.errorMessage,
          contains('Esta comanda está vazia no sistema.'),
        );
      },
    );
  });
}
