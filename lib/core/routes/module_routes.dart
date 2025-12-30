import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/features/home/view/home_page.dart';
import 'package:djorder/features/settings/view/settings_page.dart';
import 'package:djorder/features/order/view/orders_monitor_page.dart';

class ModuleRoutes extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => HomePage());
    r.child('/settings', child: (_) => SettingsPage());
    r.child('/manager', child: (_) => OrdersMonitorPage());
  }
}
