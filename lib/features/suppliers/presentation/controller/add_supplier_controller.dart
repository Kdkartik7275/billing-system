import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/supplier/add_supplier_usecase.dart';
import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSupplierController extends GetxController {
  final AddSupplierUsecase addSupplierUsecase;

  AddSupplierController({required this.addSupplierUsecase});

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final gstController = TextEditingController();

  final isActive = true.obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  static final _phoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _gstRegex = RegExp(
    r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('AddSupplier');
  }

  @override
  void onClose() {
    nameController.dispose();
    contactPersonController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    gstController.dispose();
    super.onClose();
  }

  void toggleActive(bool value) => isActive.value = value;

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter the supplier\'s name';
    }
    return null;
  }

  String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    if (!_phoneRegex.hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null; // optional
    if (!_emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateGst(String? value) {
    final gst = value?.trim().toUpperCase() ?? '';
    if (gst.isEmpty) return null; // optional
    if (!_gstRegex.hasMatch(gst)) {
      return 'Enter a valid 15-character GSTIN';
    }
    return null;
  }

  String? _orNull(TextEditingController c) {
    final value = c.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await addSupplierUsecase.call(
        SupplierEntity(
          id: generateId(),
          name: nameController.text.trim(),
          contactPerson: _orNull(contactPersonController),
          phone: _orNull(phoneController),
          email: _orNull(emailController),
          address: _orNull(addressController),
          gstNumber: gstController.text.trim().isEmpty
              ? null
              : gstController.text.trim().toUpperCase(),
          isActive: isActive.value,
          createdAt: DateTime.now(),
        ),
      );

      result.fold(
        (err) {
          errorMessage.value = "Unable to add supplier. Please try again.";

          AnalyticsService.logEvent(
            'supplier_add_failed',
            parameters: {'error': err.message},
          );
        },
        (r) {
          Get.back();
          AppSnackbar.success(message: 'Supplier added successfully.');
          Get.find<SuppliersController>().addSupplier(r);

          AnalyticsService.logEvent('supplier_add_success');
        },
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      debugPrint(e.toString());

      AnalyticsService.logEvent(
        'supplier_add_failed',
        parameters: {'error': e.toString()},
      );
    } finally {
      isLoading.value = false;
    }
  }
}
