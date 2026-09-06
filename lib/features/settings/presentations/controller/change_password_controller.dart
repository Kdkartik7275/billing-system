import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:billing_system/features/authentication/domain/usecases/change_password_usecase.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordUsecase changePasswordUsecase;
  ChangePasswordController({required this.changePasswordUsecase});

  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  final isLoading = false.obs;
  final isDone = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('ChangePassword');
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleObscureCurrent() => obscureCurrent.value = !obscureCurrent.value;
  void toggleObscureNew() => obscureNew.value = !obscureNew.value;
  void toggleObscureConfirm() => obscureConfirm.value = !obscureConfirm.value;

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a new password';
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (password == currentPasswordController.text) {
      return 'New password must be different from the current one';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return 'Confirm your new password';
    if (confirm != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      await _changePassword();
      isDone.value = true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (currentPassword == newPassword) {
      AppSnackbar.error(
        message: 'New password must be different from your current password.',
      );

      await AnalyticsService.logEvent(
        'change_password_failed',
        parameters: {'reason': 'same_as_current'},
      );

      return;
    }

    try {
      final result = await changePasswordUsecase.call(
        ChangePasswordParams(
          oldPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

      result.fold(
        (failure) {
          AppSnackbar.error(
            message: 'Unable to change password. Please try again.',
          );

          AnalyticsService.logEvent(
            'change_password_failed',
            parameters: {'reason': failure.message},
          );
        },
        (_) {
          AppSnackbar.success(message: 'Password changed successfully.');

          currentPasswordController.clear();
          newPasswordController.clear();

          AnalyticsService.logEvent('change_password_success');
        },
      );
    } catch (e) {
      AppSnackbar.error(
        message: 'Something went wrong while changing your password.',
      );

      AnalyticsService.logEvent(
        'change_password_failed',
        parameters: {'reason': 'unknown_error', 'error': e.toString()},
      );
    }
  }
}
