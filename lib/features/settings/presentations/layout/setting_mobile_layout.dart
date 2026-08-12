import 'package:billing_system/features/settings/presentations/widgets/account_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/logout_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/nav_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/security_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_info.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_information_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/subscription_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/user_information_card.dart';
import 'package:flutter/material.dart';

class SettingMobileLayout extends StatelessWidget {
  const SettingMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            ShopInformationCard(onEdit: () {}),
            const SizedBox(height: 16),
            BusinessDetailsCard(),
            const SizedBox(height: 16),
            SubscriptionCard(),
            const SizedBox(height: 16),
            UserInformationCard(),
            const SizedBox(height: 16),
            SecurityCard(onChangePassword: () {}, onViewSessions: () {}),
            const SizedBox(height: 16),
            AccountCard(
              onManageStaff: () {},
              onConnectedDevices: () {},
              onExportData: () {},
            ),
            const SizedBox(height: 16),
            NotificationsRow(),
            const SizedBox(height: 12),
            PrivacyRow(),
            const SizedBox(height: 12),
            PreferencesRow(),
            const SizedBox(height: 12),
            HelpSupportRow(),
            const SizedBox(height: 12),
            AboutRow(),
            const SizedBox(height: 16),
            LogoutCard(),
          ],
        ),
      ),
    );
  }
}
