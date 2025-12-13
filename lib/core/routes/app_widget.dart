import 'package:djorder/core/utils/app_colors.dart';
import 'package:djorder/shared/order_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DJOrder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF180E6D),
        extensions: const <ThemeExtension<dynamic>>[
          OrderStatusTheme(
            freeColor: AppColors.orderStatusFree,
            busyColor: AppColors.orderStatusBusy,
            lockColor: AppColors.orderStatusLock,
          ),
        ],
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
