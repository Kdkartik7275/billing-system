import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (kIsWeb) {
      debugPrint('[Analytics Event] $name ${parameters ?? ''}');
      return;
    }

    await _instance.logEvent(name: name, parameters: parameters);
  }

  static Future<void> setUserId(String userId) async {
    if (kIsWeb) {
      debugPrint('[Analytics User] $userId');
      return;
    }

    await _instance.setUserId(id: userId);
  }

  static Future<void> setUserProperty(String name, String? value) async {
    if (kIsWeb) {
      debugPrint('[Analytics Property] $name = $value');
      return;
    }

    await _instance.setUserProperty(name: name, value: value);
  }

  static Future<void> logScreenView(String screenName) async {
    if (kIsWeb) {
      debugPrint('[Analytics Screen] $screenName');
      return;
    }

    await _instance.logScreenView(screenName: screenName);
  }
}
