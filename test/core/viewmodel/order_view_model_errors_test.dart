import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
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
