import 'package:billing_system/features/settings/presentations/widgets/account_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/logout_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/nav_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/security_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_info.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_information_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/subscription_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/user_information_card.dart';
import 'package:flutter/material.dart';
class SettingTabletLayout extends StatelessWidget {
  const SettingTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      ShopInformationCard(),
                      const SizedBox(height: 20),
                      BusinessDetailsCard(),
                      const SizedBox(height: 20),
                      SecurityCard(
                        onChangePassword: () {},
                        onViewSessions: () {},
                      ),
                      const SizedBox(height: 20),
                      AccountCard(
                        onManageStaff: () {},
                        onConnectedDevices: () {},
                        onExportData: () {},
                      ),
                      const SizedBox(height: 20),
                      LogoutCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Right column
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      UserInformationCard(),
                      const SizedBox(height: 20),
                      SubscriptionCard(),
                      const SizedBox(height: 20),
                      NotificationsRow(),
                      const SizedBox(height: 14),
                      PrivacyRow(),
                      const SizedBox(height: 14),
                      PreferencesRow(),
                      const SizedBox(height: 14),
                      HelpSupportRow(),
                      const SizedBox(height: 14),
                      AboutRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
