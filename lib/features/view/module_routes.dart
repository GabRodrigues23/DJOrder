import 'package:djorder/features/view/home/home_page.dart';
import 'package:djorder/features/view/monitor/orders_monitor_page.dart';
import 'package:djorder/features/view/settings/settings_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ModuleRoutes extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => HomePage());
    r.child('/settings', child: (_) => SettingsPage());
    r.child('/manager', child: (_) => OrdersMonitorPage());
  }
}
