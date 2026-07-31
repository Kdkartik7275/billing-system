import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_tablet_body.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardTabletLayout extends StatefulWidget {
  const DashboardTabletLayout({super.key});

  static const Map<DashboardMenu, Widget> _pages = {
    DashboardMenu.dashboard: TabletDashboardBody(),
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
  State<DashboardTabletLayout> createState() => _DashboardTabletLayoutState();
}

class _DashboardTabletLayoutState extends State<DashboardTabletLayout> {
  final controller = Get.find<DashboardShellController>();

  static const double _collapsedWidth = 72;
  static const double _expandedWidth = 216;

  bool _isSidebarExpanded = false;

  // final inventoryController = Get.find<InventoryController>();
  // @override
  // void initState() {
  //   super.initState();
  //   inventoryController.getProducts();
  // }

  void _toggleSidebar() {
    setState(() => _isSidebarExpanded = !_isSidebarExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Row(
        children: [
          // Icon-only / expandable sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: _isSidebarExpanded ? _expandedWidth : _collapsedWidth,
            child: ClipRect(
              child: _TabletSidebar(
                expanded: _isSidebarExpanded,
                onToggleExpanded: _toggleSidebar,
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
                        DashboardTabletLayout._pages[controller
                            .selectedMenu
                            .value] ??
                        const Center(child: Text('Dashboard')),
                  ),
                ),
        ],
      ),
    );
  }
}


class _TabletSidebar extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggleExpanded;

  const _TabletSidebar({
    required this.expanded,
    required this.onToggleExpanded,
  });

  static const _items = [
    (
      icon: Icons.dashboard_outlined,
      menu: DashboardMenu.dashboard,
      label: 'Dashboard',
    ),
    (icon: Icons.shopping_cart_outlined, menu: DashboardMenu.pos, label: 'POS'),
    (
      icon: Icons.inventory_2_outlined,
      menu: DashboardMenu.inventory,
      label: 'Inventory',
    ),
    (
      icon: Icons.show_chart_outlined,
      menu: DashboardMenu.sales,
      label: 'Sales',
    ),
    (
      icon: Icons.people_outline,
      menu: DashboardMenu.customers,
      label: 'Customers',
    ),
    (
      icon: Icons.badge_outlined,
      menu: DashboardMenu.employees,
      label: 'Employees',
    ),
    (
      icon: Icons.local_shipping_outlined,
      menu: DashboardMenu.suppliers,
      label: 'Suppliers',
    ),
    (
      icon: Icons.bar_chart_outlined,
      menu: DashboardMenu.reports,
      label: 'Reports',
    ),
    (
      icon: Icons.settings_outlined,
      menu: DashboardMenu.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardShellController>();
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Logo + collapse/expand toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: expanded
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (expanded)
                    _ToggleButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: onToggleExpanded,
                    ),
                ],
              ),
            ),

            if (!expanded) ...[
              const SizedBox(height: 8),
              _ToggleButton(
                icon: Icons.chevron_right_rounded,
                onTap: onToggleExpanded,
              ),
            ],

            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 8),

            Expanded(
              child: Obx(
                () => ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  children: _items.map((e) {
                    final selected = controller.selectedMenu.value == e.menu;

                    final row = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e.icon,
                          size: 20,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        if (expanded) ...[
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              e.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );

                    final tile = GestureDetector(
                      onTap: () => controller.changeMenu(e.menu),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        height: 44,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: expanded ? 12 : 0,
                        ),
                        alignment: expanded
                            ? Alignment.centerLeft
                            : Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF2563EB)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: row,
                      ),
                    );

                    // Tooltip only makes sense when labels aren't visible.
                    return expanded
                        ? tile
                        : Tooltip(
                            message: e.label,
                            preferBelow: false,
                            child: tile,
                          );
                  }).toList(),
                ),
              ),
            ),

            // User avatar at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: expanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2563EB),
                    ),
                    child: const Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Admin',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ToggleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TabletTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Obx(() {
            final controller = Get.find<DashboardShellController>();
            final label = controller.selectedMenu.value.name;
            final title = label[0].toUpperCase() + label.substring(1);
            return Text(title, style: tt.titleMedium);
          }),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              size: 20,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.dark_mode_outlined,
              size: 20,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
