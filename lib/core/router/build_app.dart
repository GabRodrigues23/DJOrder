import 'package:djorder/core/router/app_router.dart';
import 'package:flutter/material.dart';

class BuildApp extends StatelessWidget {
  const BuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DJOrder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF180E6D),
      ),
      routerConfig: AppRouter().router,
    );
  }
}
