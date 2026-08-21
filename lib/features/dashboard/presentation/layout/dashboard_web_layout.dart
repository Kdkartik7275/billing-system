import 'package:billing_system/core/config/constants/dashboard_pages.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardWebLayout extends StatefulWidget {
  const DashboardWebLayout({super.key});

  @override
  State<DashboardWebLayout> createState() => _DashboardWebLayoutState();
}

class _DashboardWebLayoutState extends State<DashboardWebLayout> {
  final controller = Get.find<DashboardShellController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ── Persistent sidebar ──────────────────────────────
          const SizedBox(width: 240, child: AppNavigationDrawer()),
          // ── Divider ─────────────────────────────────────────
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),
          // ── Main content ────────────────────────────────────
          Expanded(
            child: Obx(
              () =>
                  pages(2)[controller.selectedMenu.value] ??
                  const Center(child: Text('Dashboard')),
            ),
          ),
        ],
      ),
    );
  }
}
