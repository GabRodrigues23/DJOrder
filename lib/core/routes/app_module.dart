import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/core/routes/module_routes.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.module('/', module: ModuleRoutes());
  }
}
