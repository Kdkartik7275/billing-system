import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/suppliers/presentation/controller/add_supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAddSupplierDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => AddSupplierDialog());
}

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({super.key});

  @override
  State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  final String _tag = UniqueKey().toString();
  late final AddSupplierController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      AddSupplierController(addSupplierUsecase: sl()),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<AddSupplierController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: _buildForm(textTheme),
        ),
      ),
    );
  }

  Widget _buildForm(TextTheme textTheme) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Supplier',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Add a new vendor to purchase products from',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          Obx(
            () => controller.errorMessage.value == null
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value!,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          _label(textTheme, 'Supplier Name *'),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.nameController,
            textInputAction: TextInputAction.next,
            autofocus: true,
            validator: controller.validateName,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'e.g. Amul Distributors',
              icon: Icons.storefront_outlined,
            ),
          ),
          const SizedBox(height: 16),

          _label(textTheme, 'Contact Person'),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.contactPersonController,
            textInputAction: TextInputAction.next,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'e.g. Ramesh Kumar',
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(textTheme, 'Phone'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: controller.validatePhone,
                      style: textTheme.bodyMedium,
                      decoration: _inputDecoration(
                        hint: '98765 43210',
                        icon: Icons.call_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _label(textTheme, 'Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: controller.validateEmail,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'vendor@example.com',
              icon: Icons.mail_outline,
            ),
          ),
          const SizedBox(height: 16),

          _label(textTheme, 'GST Number'),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.gstController,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            validator: controller.validateGst,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: '22AAAAA0000A1Z5',
              icon: Icons.receipt_long_outlined,
            ),
          ),
          const SizedBox(height: 16),

          _label(textTheme, 'Address'),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.addressController,
            textInputAction: TextInputAction.done,
            minLines: 2,
            maxLines: 3,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'Warehouse / office address',
              icon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 18),

          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE1E5EC)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Supplier',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Inactive suppliers won\'t appear in purchase forms',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: controller.isActive.value,
                    activeThumbColor: AppColors.primary,
                    onChanged: controller.toggleActive,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Obx(
            () => SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          key: const ValueKey('label'),
                          'Add Supplier',
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Cancel',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(TextTheme textTheme, String text) {
    return Text(
      text,
      style: textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE1E5EC)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.primary.withValues(alpha: 0.55),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
