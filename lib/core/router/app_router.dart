import 'package:djorder/core/constants/app_routes.dart';
import 'package:djorder/features/home/view/home_page.dart';
import 'package:djorder/features/order/view/orders_monitor_page.dart';
import 'package:djorder/features/settings/view/settings_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.monitor,
        name: 'monitor',
        builder: (context, state) => const OrdersMonitorPage(),
      ),
    ],
  );
}
