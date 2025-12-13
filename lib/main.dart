import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/core/routes/app_widget.dart';
import 'package:djorder/core/routes/app_module.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1280, 720),
    center: true,
    title: 'DJORDER',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
