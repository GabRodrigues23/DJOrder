import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:window_manager/window_manager.dart';
import 'package:djorder/features/service/settings_service.dart';
import 'package:djorder/core/routes/app_module.dart';
import 'package:djorder/core/routes/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await SettingsService().init();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1024, 768),
    center: true,
    title: 'DJORDER',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
