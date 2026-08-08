import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/views/billing_page.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_body.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/logout_button.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardMobileLayout extends StatefulWidget {
  const DashboardMobileLayout({super.key});

  static const Map<DashboardMenu, Widget> _pages = {
    DashboardMenu.dashboard: MobileDashboardBody(),
    DashboardMenu.pos: BillingPage(),
    DashboardMenu.inventory: InventoryPage(),
    DashboardMenu.sales: Center(child: Text('Sales')),
    DashboardMenu.customers: Center(child: Text('Customers')),
    DashboardMenu.employees: Center(child: Text('Employees')),
    DashboardMenu.suppliers: Center(child: Text('Suppliers')),
    DashboardMenu.reports: Center(child: Text('Reports')),
    DashboardMenu.settings: Center(child: Text('Settings')),
  };

  @override
  State<DashboardMobileLayout> createState() => _DashboardMobileLayoutState();
}

class _DashboardMobileLayoutState extends State<DashboardMobileLayout> {
  final controller = Get.find<DashboardShellController>();

  final billsController = Get.find<BillingController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F14),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        toolbarHeight: 76,
        title: Builder(
          builder: (context) => Row(
            children: [
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Hello, Admin ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text('👋', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Here's what's happening today",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [LogoutButton(), const SizedBox(width: 14)],
      ),
      drawer: const Drawer(elevation: 0, child: AppNavigationDrawer()),
      body: Obx(
        () =>
            DashboardMobileLayout._pages[controller.selectedMenu.value] ??
            const Center(child: Text('Dashboard')),
      ),
    );
  }
}
