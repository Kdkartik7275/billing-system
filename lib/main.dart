import 'package:billing_system/app/app.dart';
import 'package:billing_system/app/bootstrap.dart';
import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  String initialRoute = AppRoutes.splash;

  try {
    await Bootstrap.initialize();
  } catch (e, stackTrace) {
    debugPrint('Bootstrap.initialize failed: $e\n$stackTrace');
    await Bootstrap.recoverFromFailure();
    initialRoute = AppRoutes.login;
  }

  runApp(MyApp(initialRoute: initialRoute));
  FlutterNativeSplash.remove();
}