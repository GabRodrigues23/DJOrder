import 'package:djorder/features/interfaces/order_repository_interface.dart';
import 'package:djorder/features/model/order.dart';
import 'package:djorder/features/viewmodel/order_view_model.dart';
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
}

void main() {
  late OrderViewModel viewModel;
  late FakeOrderRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeOrderRepository();
    viewModel = OrderViewModel(fakeRepository);
  });

  group('OrderViewModel: Erro e Estado Vazio', () {
    test(
      'Deve devolver um erro de conexão com servidor (Update errorMessage)',
      () async {
        fakeRepository.shouldThrowError = true;
        await viewModel.loadData();

        expect(viewModel.orders.isEmpty, true);
        expect(viewModel.isLoading, false);
        expect(viewModel.errorMessage, contains('Falha na conexão'));
      },
    );
    test('Deve devolver uma lista vazia (No products foung)', () async {
      fakeRepository.shouldThrowError = false;
      fakeRepository.mockList = [];

      await viewModel.loadData();

      expect(viewModel.errorMessage, isEmpty);
      expect(viewModel.orders.isEmpty, true);
      expect(viewModel.isLoading, false);
    });

    test(
      'Deve limpar errorMessage quando "Tentar Novamente" com sucesso',
      () async {
        fakeRepository.shouldThrowError = true;

        await viewModel.loadData();

        expect(viewModel.errorMessage, isNotEmpty);

        fakeRepository.shouldThrowError = false;
        fakeRepository.mockList = [Order.empty(1)];

        await viewModel.loadData();

        expect(viewModel.errorMessage, isEmpty);
        expect(viewModel.orders.length, isNotEmpty);
      },
    );
  });
}
