import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/info_row.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopInformationCard extends GetView<UserController> {
  final VoidCallback? onEdit;

  const ShopInformationCard({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shop = controller.shop.value!;
      return CardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              icon: Icons.storefront_rounded,
              iconBg: const Color(0xFFE3EEFF),
              iconColor: AppColors.primary,
              title: 'Shop Information',
              onEdit: onEdit,
            ),
            const SizedBox(height: 12),

            Divider(height: 12, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.badge_outlined,
              label: 'Shop ID',
              value: shop.id,
            ),
            InfoRow(
              icon: Icons.storefront_outlined,
              label: 'Shop Name',
              value: shop.shopName,
            ),
            InfoRow(
              icon: Icons.person_outline,
              label: 'Owner Name',
              value: shop.ownerName,
            ),
            InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: shop.ownerEmail,
            ),
            InfoRow(
              icon: Icons.call_outlined,
              label: 'Phone',
              value: shop.ownerPhone,
            ),
            InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: shop.address,
              showDivider: false,
            ),
          ],
        ),
      );
    });
  }
}
