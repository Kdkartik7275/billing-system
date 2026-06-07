import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_body.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';
import 'package:billing_system/features/pos/presentation/pages/pos_biiling_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardWebLayout extends StatelessWidget {
  const DashboardWebLayout({super.key});

  static const Map<DashboardMenu, Widget> _pages = {
    DashboardMenu.dashboard: DashboardBody(),
    DashboardMenu.pos:       POSBillingPage(),
    DashboardMenu.inventory: InventoryPage(),
    DashboardMenu.sales:     Center(child: Text('Sales')),
    DashboardMenu.customers: Center(child: Text('Customers')),
    DashboardMenu.employees: Center(child: Text('Employees')),
    DashboardMenu.suppliers: Center(child: Text('Suppliers')),
    DashboardMenu.reports:   Center(child: Text('Reports')),
    DashboardMenu.settings:  Center(child: Text('Settings')),
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardShellController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ── Persistent sidebar ──────────────────────────────
          const SizedBox(
            width: 240,
            child: AppNavigationDrawer(),
          ),
          // ── Divider ─────────────────────────────────────────
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          // ── Main content ────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _WebTopBar(),
                Expanded(
                  child: Obx(
                    () => _pages[controller.selectedMenu.value] ??
                        const Center(child: Text('Dashboard')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Obx(() {
            final controller = Get.find<DashboardShellController>();
            // Capitalise first letter for the title
            final label = controller.selectedMenu.value.name;
            final title = label[0].toUpperCase() + label.substring(1);
            return Text(title, style: tt.titleMedium);
          }),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined, size: 20,color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode_outlined, size: 20,color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined, size: 20,color: Colors.black)),
        ],
      ),
    );
  }
}