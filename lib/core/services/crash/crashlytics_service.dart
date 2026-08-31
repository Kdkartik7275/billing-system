import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  CrashlyticsService._();

  static final FirebaseCrashlytics _instance = FirebaseCrashlytics.instance;

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (kIsWeb) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('Crashlytics Error (Web)');
      debugPrint('Error: $error');
      debugPrint('Reason: ${reason ?? 'N/A'}');
      debugPrint('Fatal: $fatal');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return;
    }

    await _instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  static Future<void> log(String message) async {
    if (kIsWeb) {
      debugPrint('[Crashlytics Log] $message');
      return;
    }

    await _instance.log(message);
  }

  static Future<void> setUserId(String userId) async {
    if (kIsWeb) {
      debugPrint('[Crashlytics User] $userId');
      return;
    }

    await _instance.setUserIdentifier(userId);
  }

  static Future<void> setCustomKey(String key, Object value) async {
    if (kIsWeb) {
      debugPrint('[Crashlytics Key] $key = $value');
      return;
    }

    await _instance.setCustomKey(key, value);
  }
}
