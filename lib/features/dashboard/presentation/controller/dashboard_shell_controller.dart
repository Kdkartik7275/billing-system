import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_menu.dart';

class DashboardShellController extends GetxController {
  final selectedMenu = DashboardMenu.dashboard.obs;

  void changeMenu(DashboardMenu menu) {
    selectedMenu.value = menu;
  }

  Future<void> refreshDashboard(
    BillingController billController,
    InventoryController inventoryController,
  ) async {
    try {
      await Future.wait([
        billController.refreshBilling(),
        inventoryController.refreshProducts(),
      ]);
    } catch (e, stackTrace) {
      debugPrint('[DashboardShell] refreshDashboard error: $e');
      debugPrint('$stackTrace');
    }
  }
}
