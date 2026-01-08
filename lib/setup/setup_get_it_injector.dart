import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/repository/order_repository.dart';
import 'package:djorder/features/order/service/order_service.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';

final getIt = GetIt.instance;

void setupGetItInjector() {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<SettingsService>(() => SettingsService());

  getIt.registerLazySingleton<OrderService>(
    () => OrderService(getIt<Dio>(), getIt<SettingsService>()),
  );

  getIt.registerLazySingleton<OrderRepositoryInterface>(
    () => OrderRepository(getIt<OrderService>()),
  );

  getIt.registerFactory<OrderViewModel>(
    () => OrderViewModel(getIt<OrderRepositoryInterface>()),
  );
}
