import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      debugPrint('[BiometricService] canCheckBiometrics: $canCheck');

      debugPrint('[BiometricService] isDeviceSupported: $isSupported');

      return canCheck && isSupported;
    } catch (e, stackTrace) {
      debugPrint('[BiometricService] isAvailable error: $e');
      debugPrint('$stackTrace');

      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();

      debugPrint('[BiometricService] Available biometrics: $biometrics');

      return biometrics;
    } catch (e, stackTrace) {
      debugPrint('[BiometricService] getAvailableBiometrics error: $e');
      debugPrint('$stackTrace');

      return [];
    }
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      debugPrint('[BiometricService] Authentication started');

      final result = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );

      debugPrint('[BiometricService] Authentication result: $result');

      return result;
    } on LocalAuthException catch (e, stackTrace) {
      debugPrint('[BiometricService] LocalAuthException: ${e.code}');
      debugPrint('[BiometricService] Message: ${e.description}');
      debugPrint('$stackTrace');

      return false;
    } catch (e, stackTrace) {
      debugPrint('[BiometricService] Authentication error: $e');
      debugPrint('$stackTrace');

      return false;
    }
  }

  Future<bool> authenticateForLogin() {
    return authenticate(reason: 'Authenticate to access your billing software');
  }
}
