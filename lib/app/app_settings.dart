import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  static const String boxName = 'settings';

  static const String biometricEnabledKey = 'biometric_enabled';

  static const String biometricSetupAskedKey = 'biometric_setup_asked';

  static Box get _box => Hive.box(boxName);

  static bool get biometricEnabled {
    return _box.get(biometricEnabledKey, defaultValue: false);
  }

  static Future<void> setBiometricEnabled(bool value) async {
    await _box.put(biometricEnabledKey, value);
  }

  static bool get biometricSetupAsked {
    return _box.get(biometricSetupAskedKey, defaultValue: false);
  }

  static Future<void> setBiometricSetupAsked(bool value) async {
    await _box.put(biometricSetupAskedKey, value);
  }
}
