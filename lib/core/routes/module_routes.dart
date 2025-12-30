import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/order/repository/order_repository.dart';
import 'package:djorder/features/order/service/order_service.dart';
import 'package:djorder/features/order/viewmodel/order_view_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/features/home/view/home_page.dart';
import 'package:djorder/features/settings/view/settings_page.dart';
import 'package:djorder/features/order/view/orders_monitor_page.dart';

class ModuleRoutes extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    i.addLazySingleton<OrderService>(() => OrderService());
    i.addLazySingleton<OrderRepositoryInterface>(() => OrderRepository(i()));
    i.addLazySingleton<OrderViewModel>(() => OrderViewModel(i()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => HomePage());
    r.child('/settings', child: (_) => SettingsPage());
    r.child('/manager', child: (_) => OrdersMonitorPage());
  }
}
