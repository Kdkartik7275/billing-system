import 'package:billing_system/app/app.dart';
import 'package:billing_system/app/bootstrap.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = (FlutterErrorDetails details) {
      CrashlyticsService.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        reason: details.context?.toString(),
        fatal: true,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      CrashlyticsService.recordError(error, stack, fatal: true);
      return true;
    };

    await AnalyticsService.logEvent('app_start');
  } else {
    debugPrint(
      '[Web] Crashlytics and Analytics disabled; using debug logs only.',
    );
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
      await AnalyticsService.logEvent(
        'bootstrap_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}
