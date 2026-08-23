import 'package:billing_system/features/settings/presentations/widgets/account_card.dart';
import 'package:billing_system/features/settings/presentations/widgets/change_password_dialog.dart';
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        ShopInformationCard(),
        const SizedBox(height: 16),
        BusinessDetailsCard(),
        const SizedBox(height: 16),
        SubscriptionCard(),
        const SizedBox(height: 16),
        UserInformationCard(),
        const SizedBox(height: 16),
        SecurityCard(
          onChangePassword: () => showChangePasswordDialog(context),
        ),
        const SizedBox(height: 16),
        AccountCard(onExportData: () {}),
        const SizedBox(height: 16),
      ],
    );
  }
}
