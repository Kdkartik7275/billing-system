import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_body.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardWebLayout extends StatefulWidget {
  const DashboardWebLayout({super.key});

  static const Map<DashboardMenu, Widget> _pages = {
    DashboardMenu.dashboard: DashboardBody(),
    DashboardMenu.pos: Center(child: Text('Sales')),
    DashboardMenu.inventory: InventoryPage(),
    DashboardMenu.sales: Center(child: Text('Sales')),
    DashboardMenu.customers: Center(child: Text('Customers')),
    DashboardMenu.employees: Center(child: Text('Employees')),
    DashboardMenu.suppliers: Center(child: Text('Suppliers')),
    DashboardMenu.reports: Center(child: Text('Reports')),
    DashboardMenu.settings: Center(child: Text('Settings')),
  };  

  @override
  State<DashboardWebLayout> createState() => _DashboardWebLayoutState();
}

class _DashboardWebLayoutState extends State<DashboardWebLayout> {
  final controller = Get.find<DashboardShellController>();

  // final inventoryController = Get.find<InventoryController>();
  // @override
  // void initState() {
  //   super.initState();
  //   inventoryController.getProducts();
  // }

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
                  DashboardWebLayout._pages[controller.selectedMenu.value] ??
                  const Center(child: Text('Dashboard')),
            ),
          ),
        ],
      ),
    );
  }
}
