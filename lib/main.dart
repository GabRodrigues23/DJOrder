import 'package:djorder/setup/setup_get_it_injector.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:djorder/core/router/build_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  setupGetItInjector();
  await getIt<SettingsService>().init();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1024, 768),
    center: true,
    title: 'DJORDER',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(BuildApp());
}
