import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/action_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/toggle_row.dart';
import 'package:flutter/material.dart';

class SecurityCard extends StatefulWidget {
  final VoidCallback? onChangePassword;
  final bool initialTwoFactor;
  final bool initialBiometric;
  final ValueChanged<bool>? onTwoFactorChanged;
  final ValueChanged<bool>? onBiometricChanged;

  const SecurityCard({
    super.key,
    this.onChangePassword,
    this.initialTwoFactor = false,
    this.initialBiometric = true,
    this.onTwoFactorChanged,
    this.onBiometricChanged,
  });

  @override
  State<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<SecurityCard> {
  late bool twoFactorEnabled = widget.initialTwoFactor;
  late bool biometricEnabled = widget.initialBiometric;

  @override
  Widget build(BuildContext context) {
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
            subtitle: 'Last changed 3 months ago',
            onTap: widget.onChangePassword,
          ),
          ToggleRow(
            icon: Icons.verified_user_outlined,
            label: 'Two-Factor Authentication',
            subtitle: 'Extra layer of security at login',
            value: twoFactorEnabled,
            onChanged: (v) {
              setState(() => twoFactorEnabled = v);
              widget.onTwoFactorChanged?.call(v);
            },
          ),
          ToggleRow(
            showDivider: false,
            icon: Icons.fingerprint,
            label: 'Biometric Login',
            subtitle: 'Use Face ID / fingerprint to sign in',
            value: biometricEnabled,
            onChanged: (v) {
              setState(() => biometricEnabled = v);
              widget.onBiometricChanged?.call(v);
            },
          ),
        ],
      ),
    );
  }
}
