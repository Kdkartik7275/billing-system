import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/info_row.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessDetailsCard extends GetView<UserController> {
  final VoidCallback? onEdit;

  const BusinessDetailsCard({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Obx(() {
        final businessDetails = controller.shop.value?.businessDetails;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              icon: Icons.assignment_outlined,
              iconBg: const Color(0xFFEDE7FE),
              iconColor: const Color(0xFF7C5CFC),
              title: 'Business Details',
              onEdit: onEdit,
            ),

            const SizedBox(height: 8),

            InfoRow(
              icon: Icons.badge_outlined,
              label: 'GST Number',
              value: businessDetails?.gstNumber ?? 'Not provided',
            ),

            InfoRow(
              icon: Icons.badge_outlined,
              label: 'PAN Number',
              value: businessDetails?.panNumber ?? 'Not provided',
            ),

            InfoRow(
              icon: Icons.apartment_outlined,
              label: 'Business Type',
              value: businessDetails?.businessType ?? 'Not provided',
            ),

            InfoRow(
              icon: Icons.map_outlined,
              label: 'State',
              value: businessDetails?.state ?? 'Not provided',
            ),

            InfoRow(
              icon: Icons.verified_outlined,
              label: 'FSSAI License',
              value: businessDetails?.fssaiLicense ?? 'Not provided',
            ),

            InfoRow(
              icon: Icons.attach_money_outlined,
              label: 'Currency',
              value: businessDetails?.currency ?? 'INR',
            ),

            InfoRow(
              icon: Icons.event_outlined,
              label: 'Financial Year Start',
              value: businessDetails?.financialYearStart ?? '1st April',
            ),
          ],
        );
      }),
    );
  }
}
