import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/config/theme/app_spacing.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: const [_DrawerHeader(), _DrawerMenu(), _DrawerUserCard()],
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
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
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RetailPro', style: tt.titleMedium),
              const SizedBox(height: 1),
              Text(
                'Enterprise POS',
                style: tt.labelMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Menu ─────────────────────────────────────────────────────────────────────

class _DrawerMenu extends StatelessWidget {
  const _DrawerMenu();

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
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final controller = Get.find<DashboardShellController>();
    // onDrawer: whether we are inside a Drawer (mobile) — if so, pop on tap
    final isInsideDrawer = Scaffold.of(context).hasDrawer;

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
    this.selected = false,
  });

  final TextTheme tt;
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2563EB) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 0,
        ),
        leading: Icon(
          icon,
          size: 18,
          color: selected ? Colors.white : const Color(0xFF111827),
        ),
        title: Text(
          title,
          style: tt.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF111827),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

// ── User card ─────────────────────────────────────────────────────────────────

class _DrawerUserCard extends GetView<UserController> {
  const _DrawerUserCard();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Obx(() {
      final user = controller.user.value;
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
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2563EB),
              ),
              child: Center(
                child: Text(
                  user?.name.substring(0, 2).toUpperCase() ?? 'OW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
