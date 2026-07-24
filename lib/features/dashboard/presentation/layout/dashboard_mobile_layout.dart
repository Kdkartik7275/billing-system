import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_body.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_drawer_navigation.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardMobileLayout extends StatefulWidget {
  const DashboardMobileLayout({super.key});

  static const Map<DashboardMenu, Widget> _pages = {
    DashboardMenu.dashboard: MobileDashboardBody(),
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
  State<DashboardMobileLayout> createState() => _DashboardMobileLayoutState();
}

class _DashboardMobileLayoutState extends State<DashboardMobileLayout> {
  final controller = Get.find<DashboardShellController>();

  // final inventoryController = Get.find<InventoryController>();
  // final billsController = Get.find<BillsController>();
  // @override
  // void initState() {
  //   super.initState();
  //   inventoryController.getProducts();
  // }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          final label = controller.selectedMenu.value.name;
          final title = label[0].toUpperCase() + label.substring(1);
          return Text(
            title,
            style: tt.titleSmall!.copyWith(color: Colors.white),
          );
        }),
        actions: [
          // Obx(() {
          //   // final pending = billsController.pendingSyncCount;
          //   // final syncing = billsController.isSyncing.value;

          //   return GestureDetector(
          //           onTap:null,
          //           child: AnimatedContainer(
          //             duration: const Duration(milliseconds: 200),
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 10,
          //               vertical: 6,
          //             ),
          //             decoration: BoxDecoration(
          //               color: Colors.white.withValues(
          //                 alpha: syncing ? 0.10 : 0.15,
          //               ),
          //               border: Border.all(
          //                 color: Colors.white.withValues(alpha: 0.25),
          //               ),
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 syncing
          //                     ? SizedBox(
          //                         width: 16,
          //                         height: 16,
          //                         child: CircularProgressIndicator(
          //                           strokeWidth: 1.8,
          //                           color: Colors.white,
          //                         ),
          //                       )
          //                     : (!syncing && pending == 0)
          //                     ? const Icon(
          //                         Icons.check_rounded,
          //                         color: Colors.white54,
          //                         size: 16,
          //                       )
          //                     : const Icon(
          //                         Icons.sync_rounded,
          //                         color: Colors.white,
          //                         size: 16,
          //                       ),

          //                 const SizedBox(width: 5),

          //                 Text(
          //                   syncing
          //                       ? 'Sync'
          //                       : (pending == 0 ? 'Synced' : 'Sync'),
          //                   style: TextStyle(
          //                     color: pending == 0 && !syncing
          //                         ? Colors.white54
          //                         : Colors.white,
          //                     fontSize: 12,
          //                     fontWeight: FontWeight.w600,
          //                     letterSpacing: 0.2,
          //                   ),
          //                 ),

          //                 if (pending > 0 && !syncing) ...[
          //                   const SizedBox(width: 5),
          //                   Container(
          //                     width: 18,
          //                     height: 18,
          //                     decoration: const BoxDecoration(
          //                       color: Colors.orange,
          //                       shape: BoxShape.circle,
          //                     ),
          //                     child: Center(
          //                       child: Text(
          //                         '$pending',
          //                         style: const TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10,
          //                           fontWeight: FontWeight.bold,
          //                           height: 1,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ],
          //             ),
          //           ),
          //         );
          // }),
          // const SizedBox(width: 4),
        ],
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
