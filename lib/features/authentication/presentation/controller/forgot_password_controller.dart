import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordUsecase forgotPasswordUsecase;

  ForgotPasswordController({required this.forgotPasswordUsecase});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final isLoading = false.obs;
  final isSent = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('ForgotPassword');
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) return 'Enter a valid email address';
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      await _forgotPassword(email: emailController.text.trim());
      isSent.value = true;

      AnalyticsService.logEvent('forgot_password_sent');
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');

      AnalyticsService.logEvent(
        'forgot_password_failed',
        parameters: {'error': e.toString()},
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _forgotPassword({required String email}) async {
    try {
      final result = await forgotPasswordUsecase.call(email.trim());

      result.fold(
        (failure) {
          AppSnackbar.error(
            message: 'Unable to send password reset email. Please try again.',
          );
        },
        (_) {
          AppSnackbar.success(
            message:
                'Password reset link has been sent to your email. Please check your inbox.',
          );
        },
      );
    } catch (e) {
      AppSnackbar.error(
        message: 'Something went wrong. Please try again later.',
      );
    }
  }

  void retry() => isSent.value = false;
}
