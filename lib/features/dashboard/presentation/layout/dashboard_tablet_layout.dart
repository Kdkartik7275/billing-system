import 'package:billing_system/core/config/constants/dashboard_pages.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardTabletLayout extends StatefulWidget {
  const DashboardTabletLayout({super.key});

  @override
  State<DashboardTabletLayout> createState() => _DashboardTabletLayoutState();
}

class _DashboardTabletLayoutState extends State<DashboardTabletLayout> {
  final controller = Get.find<DashboardShellController>();

  static const double _collapsedWidth = 72;
  static const double _expandedWidth = 216;

  bool _isSidebarExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon-only / expandable sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: _isSidebarExpanded ? _expandedWidth : _collapsedWidth,
            child: ClipRect(
              child: AppNavigationDrawer(
                isTablet: true,
                expanded: _isSidebarExpanded,
                onToggleExpanded: () =>
                    setState(() => _isSidebarExpanded = !_isSidebarExpanded),
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),
          // Main content
          Expanded(
            child: Obx(
              () =>
                  pages(1)[controller.selectedMenu.value] ??
                  const Center(child: Text('Dashboard')),
            ),
          ),
        ],
      ),
    );
  }
}
