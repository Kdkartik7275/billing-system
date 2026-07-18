import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/pos/presentation/controller/bills_controller.dart';
import 'package:get/get.dart';

import '../models/dashboard_menu.dart';

class DashboardShellController extends GetxController {
  final selectedMenu = DashboardMenu.dashboard.obs;

  void changeMenu(DashboardMenu menu) {
    selectedMenu.value = menu;
  }

  Future<void> refreshDashboard() async {
    final inventoryController = Get.find<InventoryController>();
    final billsController = Get.find<BillsController>();

    Future.wait([
      inventoryController.getProducts(),
      billsController.getBills(),
      billsController.getLastSevenDaysSales(),
      billsController.getPendingBills(),
    ]);
  }
}
