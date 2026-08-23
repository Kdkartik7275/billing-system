import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/settings/presentations/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showChangePasswordDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => ChangePasswordDialog());
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final String _tag = UniqueKey().toString();
  late final ChangePasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ChangePasswordController(changePasswordUsecase: sl()),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<ChangePasswordController>(tag: _tag);
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
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Obx(
            () => controller.isDone.value
                ? _buildSuccess(textTheme)
                : _buildForm(textTheme),
          ),
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
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.password_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Change password',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your current password and choose a new one.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          if (controller.errorMessage.value != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            const SizedBox(height: 16),
          ],

          Text(
            'Current password',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.currentPasswordController,
            obscureText: controller.obscureCurrent.value,
            textInputAction: TextInputAction.next,
            autofocus: true,
            validator: controller.validateCurrentPassword,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: '••••••••',
              obscured: controller.obscureCurrent.value,
              onToggleObscure: controller.toggleObscureCurrent,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'New password',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.newPasswordController,
            obscureText: controller.obscureNew.value,
            textInputAction: TextInputAction.next,
            validator: controller.validateNewPassword,
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'At least 8 characters',
              obscured: controller.obscureNew.value,
              onToggleObscure: controller.toggleObscureNew,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Confirm new password',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirm.value,
            textInputAction: TextInputAction.done,
            validator: controller.validateConfirmPassword,
            onFieldSubmitted: (_) => controller.submit(),
            style: textTheme.bodyMedium,
            decoration: _inputDecoration(
              hint: 'Re-enter new password',
              obscured: controller.obscureConfirm.value,
              onToggleObscure: controller.toggleObscureConfirm,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.submit,
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
                        'Update password',
                        style: textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),

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

  // --------------------------------------------------------------------
  // SUCCESS STATE
  // --------------------------------------------------------------------

  Widget _buildSuccess(TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xff2E7D32).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xff2E7D32),
            size: 24,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Password updated',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your password has been changed successfully. '
          'Use your new password the next time you sign in.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Done',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool obscured,
    required VoidCallback onToggleObscure,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE1E5EC)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38),
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 20,
        color: AppColors.primary.withValues(alpha: 0.55),
      ),
      suffixIcon: IconButton(
        splashRadius: 18,
        icon: Icon(
          obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: AppColors.primary.withValues(alpha: 0.55),
        ),
        onPressed: onToggleObscure,
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
