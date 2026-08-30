import 'package:billing_system/app/app_settings.dart';
import 'package:billing_system/core/security/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiometricController extends GetxController {
  final BiometricService _biometricService = BiometricService();

  final RxBool isEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAvailable = false.obs;
  @override
  void onInit() {
    super.onInit();

    loadBiometricStatus();
    checkBiometricAvailability();
  }

  void loadBiometricStatus() {
    isEnabled.value = AppSettings.biometricEnabled;

    debugPrint('[Biometric] Current enabled status: ${isEnabled.value}');
  }

  Future<void> checkBiometricAvailability() async {
    try {
      final available = await _biometricService.isAvailable();

      if (!available) {
        isAvailable.value = false;
        return;
      }

      final biometrics = await _biometricService.getAvailableBiometrics();

      isAvailable.value = biometrics.isNotEmpty;

      debugPrint('[Biometric] Available: ${isAvailable.value}');
    } catch (e, stackTrace) {
      isAvailable.value = false;

      debugPrint('[Biometric] Availability check failed: $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> checkBiometricSetup() async {
    try {
      debugPrint('[Biometric] Checking biometric setup');

      final biometricEnabled = AppSettings.biometricEnabled;
      final setupAsked = AppSettings.biometricSetupAsked;

      if (biometricEnabled) {
        debugPrint('[Biometric] Already enabled. Skipping setup.');
        isEnabled.value = true;
        return;
      }

      if (setupAsked) {
        debugPrint('[Biometric] Setup already asked. Skipping.');
        return;
      }

      final available = await _biometricService.isAvailable();

      debugPrint('[Biometric] Device available: $available');

      if (!available) {
        debugPrint('[Biometric] Biometric is not available.');
        return;
      }

      final biometrics = await _biometricService.getAvailableBiometrics();

      debugPrint('[Biometric] Available biometrics: $biometrics');

      if (biometrics.isEmpty) {
        debugPrint('[Biometric] No biometric credentials enrolled.');
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      await showBiometricSetupDialog();
    } catch (e, stackTrace) {
      debugPrint('[Biometric] checkBiometricSetup error: $e');
      debugPrint('$stackTrace');
    }
  }

  // ---------------------------------------------------------------------------
  // SETUP DIALOG
  // ---------------------------------------------------------------------------

  Future<void> showBiometricSetupDialog() async {
    try {
      if (Get.isDialogOpen == true) {
        return;
      }

      await Get.dialog(
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: Get.theme.colorScheme.primary,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Secure your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Use your fingerprint or Face ID to quickly '
                  'and securely access your billing software.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: skipBiometricSetup,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: FilledButton(
                        onPressed: enableBiometric,
                        style: FilledButton.styleFrom(
                          backgroundColor: Get.theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Enable',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e, stackTrace) {
      debugPrint('[Biometric] showBiometricSetupDialog error: $e');
      debugPrint('$stackTrace');
    }
  }

  // ---------------------------------------------------------------------------
  // ENABLE
  // ---------------------------------------------------------------------------

  Future<bool> enableBiometric() async {
    try {
      isLoading.value = true;

      debugPrint('[Biometric] Starting authentication...');

      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to enable biometric login',
      );

      if (!authenticated) {
        debugPrint('[Biometric] Authentication failed/cancelled');
        return false;
      }

      await AppSettings.setBiometricEnabled(true);
      await AppSettings.setBiometricSetupAsked(true);

      isEnabled.value = true;

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Biometric Enabled',
        'Biometric authentication has been enabled.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('[Biometric] enableBiometric error: $e');
      debugPrint('$stackTrace');

      Get.snackbar(
        'Biometric Error',
        'Unable to enable biometric authentication.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // DISABLE
  // ---------------------------------------------------------------------------

  Future<bool> disableBiometric() async {
    try {
      isLoading.value = true;

      await AppSettings.setBiometricEnabled(false);

      isEnabled.value = false;

      Get.snackbar(
        'Biometric Disabled',
        'Biometric authentication has been disabled.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('[Biometric] disableBiometric error: $e');
      debugPrint('$stackTrace');

      Get.snackbar(
        'Biometric Error',
        'Unable to disable biometric authentication.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // TOGGLE
  // ---------------------------------------------------------------------------

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      await enableBiometric();
    } else {
      await disableBiometric();
    }
  }

  // ---------------------------------------------------------------------------
  // SKIP SETUP
  // ---------------------------------------------------------------------------

  Future<void> skipBiometricSetup() async {
    try {
      await AppSettings.setBiometricSetupAsked(true);

      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e, stackTrace) {
      debugPrint('[Biometric] skipBiometricSetup error: $e');
      debugPrint('$stackTrace');
    }
  }
}
