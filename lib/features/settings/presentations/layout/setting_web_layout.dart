import 'package:billing_system/features/settings/presentations/widgets/account_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/security_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_info.dart';
import 'package:billing_system/features/settings/presentations/widgets/shop_information_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/subscription_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/user_information_card.dart';
import 'package:flutter/material.dart';

class SettingWebLayout extends StatelessWidget {
  const SettingWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF15151A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your shop and account',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1 -- shop identity
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          ShopInformationCard(),
                          const SizedBox(height: 20),
                          BusinessDetailsCard(),
                          const SizedBox(height: 20),
                          SubscriptionCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Column 2 -- account & security
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          UserInformationCard(),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
