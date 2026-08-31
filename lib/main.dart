import 'package:billing_system/app/app.dart';
import 'package:billing_system/app/bootstrap.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics is supported on Android/iOS, not Flutter Web.
  if (!kIsWeb) {
    // Catch Flutter framework errors.
    FlutterError.onError = (FlutterErrorDetails details) {
      CrashlyticsService.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        reason: details.context?.toString(),
        fatal: true,
      );
    };

    // Catch uncaught asynchronous errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      CrashlyticsService.recordError(error, stack, fatal: true);

      return true;
    };
  }

  try {
    await Bootstrap.initialize();
  } catch (e, stackTrace) {
    if (!kIsWeb) {
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'Bootstrap initialization failed',
        fatal: true,
      );
    }

    try {
      await Bootstrap.recoverFromFailure();
    } catch (recoveryError, recoveryStackTrace) {
      if (!kIsWeb) {
        await CrashlyticsService.recordError(
          recoveryError,
          recoveryStackTrace,
          reason: 'Bootstrap recovery failed',
          fatal: true,
        );
      }
    }
  }

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}
