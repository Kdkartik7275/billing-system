import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/action_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/confirm_logout.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String language;
  final String timeZone;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onTimeZoneTap;
  final VoidCallback? onManageStaff;
  final VoidCallback? onConnectedDevices;
  final VoidCallback? onExportData;

  const AccountCard({
    super.key,
    this.language = 'English (India)',
    this.timeZone = 'GMT+5:30 (IST)',
    this.onLanguageTap,
    this.onTimeZoneTap,
    this.onManageStaff,
    this.onConnectedDevices,
    this.onExportData,
  });

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            icon: Icons.manage_accounts_outlined,
            iconBg: const Color(0xFFFFF1D9),
            iconColor: const Color(0xFFE79A1E),
            title: 'Account',
          ),
          const SizedBox(height: 8),
          ActionRow(
            icon: Icons.language_outlined,
            label: 'Language',
            subtitle: language,
            onTap: onLanguageTap,
          ),
          ActionRow(
            icon: Icons.public_outlined,
            label: 'Time Zone',
            subtitle: timeZone,
            onTap: onTimeZoneTap,
          ),
          ActionRow(
            icon: Icons.groups_2_outlined,
            label: 'Staff & Team Access',
            subtitle: 'Manage who can access this shop',
            onTap: onManageStaff,
          ),
          ActionRow(
            icon: Icons.devices_other_outlined,
            label: 'Connected Devices',
            subtitle: '2 devices linked to this account',
            onTap: onConnectedDevices,
          ),
          ActionRow(
            icon: Icons.download_outlined,
            label: 'Export Account Data',
            subtitle: 'Download a copy of your shop data',
            showDivider: false,
            onTap: onExportData,
          ),
          ActionRow(
            icon: Icons.logout,
            label: 'Log Out',
            subtitle: 'Sign out of your account',
            showDivider: false,
            onTap: () => confirmLogout(context),
            labelColor: Colors.red,
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
