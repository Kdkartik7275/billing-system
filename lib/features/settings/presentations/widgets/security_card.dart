import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/controller/biometric_controller.dart';
import 'package:billing_system/features/settings/presentations/widgets/action_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityCard extends StatelessWidget {
  final VoidCallback? onChangePassword;

  final bool initialTwoFactor;
  final ValueChanged<bool>? onTwoFactorChanged;

  const SecurityCard({
    super.key,
    this.onChangePassword,
    this.initialTwoFactor = false,
    this.onTwoFactorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final biometricController = Get.find<BiometricController>();

    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            icon: Icons.shield_outlined,
            iconBg: const Color(0xFFE3EEFF),
            iconColor: const Color(0xFF2F6FED),
            title: 'Security',
          ),

          const SizedBox(height: 8),

          ActionRow(
            icon: Icons.lock_outline,
            label: 'Change Password',
            subtitle: 'Change your account password',
            onTap: onChangePassword,
          ),

          Obx(
            () => ToggleRow(
              showDivider: biometricController.isAvailable.value,
              icon: Icons.verified_user_outlined,
              label: 'Two-Factor Authentication',
              subtitle: 'Extra layer of security at login',
              value: initialTwoFactor,
              onChanged: onTwoFactorChanged ?? (_) {},
            ),
          ),

          Obx(() {
            if (!biometricController.isAvailable.value) {
              return const SizedBox.shrink();
            }

            return ToggleRow(
              showDivider: false,
              icon: Icons.fingerprint,
              label: 'Biometric Login',
              subtitle: 'Use Face ID / fingerprint to sign in',
              value: biometricController.isEnabled.value,
              onChanged: biometricController.toggleBiometric,
            );
          }),
        ],
      ),
    );
  }
}
