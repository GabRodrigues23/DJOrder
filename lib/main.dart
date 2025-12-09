import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:djorder/core/routes/app_widget.dart';
import 'package:djorder/core/routes/app_module.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
