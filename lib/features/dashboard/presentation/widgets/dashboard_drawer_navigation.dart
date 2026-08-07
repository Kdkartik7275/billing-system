import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/config/theme/app_spacing.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNavigationDrawer extends StatelessWidget {
  final bool isTablet;
  final bool expanded;
  final VoidCallback? onToggleExpanded;

  const AppNavigationDrawer({
    super.key,
    this.isTablet = false,
    this.expanded = true,
    this.onToggleExpanded,
  }) : assert(
         !isTablet || onToggleExpanded != null,
         'onToggleExpanded is required when isTablet is true',
       );

  @override
  Widget build(BuildContext context) {
    final bool showExpanded = !isTablet || expanded;

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(
              isTablet: isTablet,
              expanded: showExpanded,
              onToggleExpanded: onToggleExpanded,
            ),
            _DrawerMenu(isTablet: isTablet, expanded: showExpanded),
            _DrawerUserCard(isTablet: isTablet, expanded: showExpanded),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.isTablet,
    required this.expanded,
    required this.onToggleExpanded,
  });

  final bool isTablet;
  final bool expanded;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Icon(
        Icons.storefront_outlined,
        color: Colors.white,
        size: 20,
      ),
    );

    if (isTablet && !expanded) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Column(
          children: [
            logo,
            const SizedBox(height: AppSpacing.sm),
            _ToggleButton(
              icon: Icons.chevron_right_rounded,
              onTap: onToggleExpanded!,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: isTablet
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShopName(),
                      const SizedBox(height: 3),
                      Text(
                        'Enterprise POS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShopName(),
                      const SizedBox(height: 3),
                      Text(
                        'Enterprise POS',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
          if (isTablet) ...[
            const SizedBox(width: AppSpacing.sm),
            _ToggleButton(
              icon: Icons.chevron_left_rounded,
              onTap: onToggleExpanded!,
            ),
          ],
        ],
      ),
    );
  }
}

class ShopName extends GetView<UserController> {
  const ShopName({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shop = controller.shop.value;
      return Text(
        shop?.shopName ?? 'RetailPro',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
          height: 1.25,
        ),
      );
    });
  }
}

class _DrawerMenu extends StatelessWidget {
  const _DrawerMenu({required this.isTablet, required this.expanded});

  final bool isTablet;
  final bool expanded;

  static const _items = [
    (
      icon: Icons.dashboard_outlined,
      title: 'Dashboard',
      menu: DashboardMenu.dashboard,
    ),
    (
      icon: Icons.shopping_cart_outlined,
      title: 'POS Billing',
      menu: DashboardMenu.pos,
    ),
    (
      icon: Icons.inventory_2_outlined,
      title: 'Inventory',
      menu: DashboardMenu.inventory,
    ),
    (
      icon: Icons.show_chart_outlined,
      title: 'Sales',
      menu: DashboardMenu.sales,
    ),
    (
      icon: Icons.people_outline,
      title: 'Customers',
      menu: DashboardMenu.customers,
    ),
    (
      icon: Icons.badge_outlined,
      title: 'Employees',
      menu: DashboardMenu.employees,
    ),
    (
      icon: Icons.local_shipping_outlined,
      title: 'Suppliers',
      menu: DashboardMenu.suppliers,
    ),
    (
      icon: Icons.bar_chart_outlined,
      title: 'Reports',
      menu: DashboardMenu.reports,
    ),
    (
      icon: Icons.settings_outlined,
      title: 'Settings',
      menu: DashboardMenu.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final controller = Get.find<DashboardShellController>();

    final isInsideDrawer = !isTablet && Scaffold.of(context).hasDrawer;

    return Expanded(
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          children: _items
              .map(
                (e) => _NavItem(
                  tt: tt,
                  icon: e.icon,
                  title: e.title,
                  expanded: expanded,
                  selected: controller.selectedMenu.value == e.menu,
                  onTap: () {
                    controller.changeMenu(e.menu);
                    if (isInsideDrawer) Navigator.of(context).pop();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tt,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.expanded,
    this.selected = false,
  });

  final TextTheme tt;
  final IconData icon;
  final String title;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: selected ? Colors.white : const Color(0xFF111827),
        ),
        if (expanded) ...[
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ],
    );

    final tile = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 44,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: expanded ? AppSpacing.md : 0),
        alignment: expanded ? Alignment.centerLeft : Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: row,
      ),
    );

    return expanded
        ? tile
        : Tooltip(message: title, preferBelow: false, child: tile);
  }
}

class _DrawerUserCard extends GetView<UserController> {
  const _DrawerUserCard({required this.isTablet, required this.expanded});

  final bool isTablet;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Obx(() {
      final user = controller.user.value;
      final avatar = Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF2563EB),
        ),
        child: Center(
          child: Text(
            user?.name.substring(0, 2).toUpperCase() ?? 'OW',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      if (!expanded) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Center(child: avatar),
        );
      }

      return Container(
        margin: const EdgeInsets.all(AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Shop User',
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    user?.role.name ?? 'Owner',
                    style: tt.labelLarge?.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
