// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:billing_system/features/authentication/domain/usecases/request_shop_registration.dart';

class RegisterShopController extends GetxController {
  final RequestShopRegistrationUseCase requestShopRegistrationUseCase;
  RegisterShopController({required this.requestShopRegistrationUseCase});

  final formKey = GlobalKey<FormState>();

  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool submitted = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('RegisterShop');
  }

  String? validateRequired(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 7) return 'Enter a valid phone number';
    return null;
  }

  Future<void> submit() async {
    errorMessage.value = null;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;
    try {
      await _submitRequest();
      submitted.value = true;

      AnalyticsService.logEvent('shop_registration_submitted');
    } catch (e, stackTrace) {
      errorMessage.value = 'Something went wrong. Please try again.';

      // Log to Crashlytics
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'RegisterShopController.submit',
        fatal: false,
      );

      // Log to Analytics (optional, for funnel tracking)
      AnalyticsService.logEvent(
        'shop_registration_failed',
        parameters: {'error': e.toString()},
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitRequest() async {
    final result = await requestShopRegistrationUseCase.call(
      RequestShopRegistrationParams(
        shopName: shopNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: int.parse(phoneController.text.trim()),
        address: addressController.text.trim(),
        additionalInformation: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      ),
    );

    result.fold((failure) {
      errorMessage.value = failure.message;
      throw Exception(failure.message);
    }, (_) {});
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
