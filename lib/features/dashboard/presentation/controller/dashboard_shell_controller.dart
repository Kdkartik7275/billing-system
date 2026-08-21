import 'package:billing_system/app/app_settings.dart';
import 'package:billing_system/core/security/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_menu.dart';

class DashboardShellController extends GetxController {
  final selectedMenu = DashboardMenu.dashboard.obs;

  final BiometricService _biometricService = BiometricService();

  @override
  void onReady() {
    super.onReady();

    debugPrint('[DashboardShell] onReady');

    checkBiometricSetup();
  }

  void changeMenu(DashboardMenu menu) {
    selectedMenu.value = menu;
  }

  Future<void> refreshDashboard() async {
    try {
      await Future.wait([
        // inventoryController.getProducts(),
        // billsController.getBills(),
        // billsController.getLastSevenDaysSales(),
        // billsController.getPendingBills(),
      ]);
    } catch (e, stackTrace) {
      debugPrint('[DashboardShell] refreshDashboard error: $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> checkBiometricSetup() async {
    try {
      debugPrint('[Biometric] Checking biometric setup');

      final biometricEnabled = AppSettings.biometricEnabled;
      final setupAsked = AppSettings.biometricSetupAsked;

      debugPrint('[Biometric] biometricEnabled: $biometricEnabled');

      debugPrint('[Biometric] biometricSetupAsked: $setupAsked');

      if (biometricEnabled) {
        debugPrint('[Biometric] Already enabled. Skipping setup.');
        return;
      }

      if (setupAsked) {
        debugPrint('[Biometric] Setup already asked. Skipping.');
        return;
      }

      final available = await _biometricService.isAvailable();

      debugPrint('[Biometric] Device available: $available');

      if (!available) {
        debugPrint('[Biometric] Biometric authentication is not available.');
        return;
      }

      final biometrics = await _biometricService.getAvailableBiometrics();

      debugPrint('[Biometric] Available biometrics: $biometrics');

      if (biometrics.isEmpty) {
        debugPrint('[Biometric] No biometric credentials enrolled.');
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      debugPrint('[Biometric] Showing biometric setup dialog');

      await showBiometricSetupDialog();
    } catch (e, stackTrace) {
      debugPrint('[Biometric] checkBiometricSetup error: $e');

      debugPrint('[Biometric] StackTrace: $stackTrace');
    }
  }

  Future<void> showBiometricSetupDialog() async {
    try {
      if (Get.isDialogOpen == true) {
        debugPrint('[Biometric] Dialog already open');
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
                // ---------------- ICON ----------------
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

                // ---------------- TITLE ----------------
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

                // ---------------- BODY ----------------
                Text(
                  'Use your fingerprint or Face ID to quickly and securely access your billing software.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- ACTIONS ----------------
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => skipBiometricSetup(),
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
                        onPressed: () => enableBiometric(),
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

      debugPrint('[Biometric] StackTrace: $stackTrace');
    }
  }

  Future<void> enableBiometric() async {
    try {
      debugPrint('[Biometric] Enable button pressed');

      debugPrint('[Biometric] Starting authentication...');

      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to enable biometric login',
      );

      debugPrint('[Biometric] Authentication result: $authenticated');

      if (!authenticated) {
        debugPrint('[Biometric] Authentication failed or cancelled');
        return;
      }

      debugPrint('[Biometric] Authentication successful');

      await AppSettings.setBiometricEnabled(true);

      debugPrint('[Biometric] biometric_enabled saved');

      await AppSettings.setBiometricSetupAsked(true);

      debugPrint('[Biometric] biometric_setup_asked saved');

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Biometric Enabled',
        'Biometric authentication has been enabled.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      debugPrint('[Biometric] Biometric setup completed successfully');
    } catch (e, stackTrace) {
      debugPrint('[Biometric] enableBiometric error: $e');

      debugPrint('[Biometric] StackTrace: $stackTrace');

      Get.snackbar(
        'Biometric Error',
        'Unable to enable biometric authentication.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> skipBiometricSetup() async {
    try {
      debugPrint('[Biometric] User selected Maybe Later');

      await AppSettings.setBiometricSetupAsked(true);

      debugPrint('[Biometric] biometric_setup_asked saved');

      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e, stackTrace) {
      debugPrint('[Biometric] skipBiometricSetup error: $e');

      debugPrint('[Biometric] StackTrace: $stackTrace');
    }
  }

  Future<void> disableBiometric() async {
    try {
      debugPrint('[Biometric] Disabling biometric authentication');

      await AppSettings.setBiometricEnabled(false);

      debugPrint('[Biometric] biometric_enabled set to false');

      Get.snackbar(
        'Biometric Disabled',
        'Biometric authentication has been disabled.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e, stackTrace) {
      debugPrint('[Biometric] disableBiometric error: $e');

      debugPrint('[Biometric] StackTrace: $stackTrace');
    }
  }
}
