
import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/info_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/status_pill.dart' show StatusPill;
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInformationCard extends GetView<UserController> {
  final VoidCallback? onEdit;
  const UserInformationCard({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              icon: Icons.person_outline,
              iconBg: const Color(0xFFFFF1D9),
              iconColor: const Color(0xFFE79A1E),
              title: 'User Information',
              onEdit: onEdit,
            ),
            const SizedBox(height: 8),
             InfoRow(
              icon: Icons.person_outline,
              label: 'Name',
              value: controller.user.value!.name,
            ),
             InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: controller.user.value!.email,
            ),
             InfoRow(
              icon: Icons.call_outlined,
              label: 'Phone',
              value: controller.user.value!.phone,
            ),
            InfoRow(
              icon: Icons.groups_outlined,
              label: 'Role',
              valueWidget:  StatusPill(
                label: controller.user.value!.role.name,
                bg: Color(0xFFFFF1D9),
                fg: Color(0xFFE79A1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}