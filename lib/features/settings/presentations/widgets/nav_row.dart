import 'package:billing_system/core/card/card_shell.dart';
import 'package:flutter/material.dart';

class SimpleNavRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback? onTap;

  const SimpleNavRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.actionLabel,
    required this.actionColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: CardShell(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15151A),
                ),
              ),
            ),
            Text(
              actionLabel,
              style: TextStyle(
                color: actionColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: actionColor),
          ],
        ),
      ),
    );
  }
}

class PrivacyRow extends StatelessWidget {
  final VoidCallback? onTap;
  const PrivacyRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleNavRow(
      icon: Icons.privacy_tip_outlined,
      iconBg: const Color(0xFFEDE7FE),
      iconColor: const Color(0xFF7C5CFC),
      title: 'Privacy Policy',
      actionLabel: 'View',
      actionColor: const Color(0xFF7C5CFC),
      onTap: onTap,
    );
  }
}

class NotificationsRow extends StatelessWidget {
  final VoidCallback? onTap;
  const NotificationsRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleNavRow(
      icon: Icons.notifications_outlined,
      iconBg: const Color(0xFFE3F7E9),
      iconColor: const Color(0xFF1E9E4E),
      title: 'Notifications',
      actionLabel: 'Manage',
      actionColor: const Color(0xFF1E9E4E),
      onTap: onTap,
    );
  }
}

class HelpSupportRow extends StatelessWidget {
  final VoidCallback? onTap;
  const HelpSupportRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleNavRow(
      icon: Icons.help_outline_rounded,
      iconBg: const Color(0xFFE3EEFF),
      iconColor: const Color(0xFF2F6FED),
      title: 'Help & Support',
      actionLabel: 'Open',
      actionColor: const Color(0xFF2F6FED),
      onTap: onTap,
    );
  }
}

class AboutRow extends StatelessWidget {
  final String version;
  final VoidCallback? onTap;
  const AboutRow({super.key, this.version = 'v1.0.0', this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleNavRow(
      icon: Icons.info_outline_rounded,
      iconBg: Colors.grey.shade200,
      iconColor: Colors.grey.shade700,
      title: 'About',
      actionLabel: version,
      actionColor: Colors.grey.shade600,
      onTap: onTap,
    );
  }
}

class PreferencesRow extends StatelessWidget {
  final VoidCallback? onTap;
  const PreferencesRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleNavRow(
      icon: Icons.settings_rounded,
      iconBg: const Color(0xFFFCE4E4),
      iconColor: const Color(0xFFE0554F),
      title: 'Preferences',
      actionLabel: 'Manage',
      actionColor: const Color(0xFFE0554F),
      onTap: onTap,
    );
  }
}
