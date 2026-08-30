
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dashboard_menu.dart';

class DashboardShellController extends GetxController {
  final selectedMenu = DashboardMenu.dashboard.obs;



  void changeMenu(DashboardMenu menu) {
    selectedMenu.value = menu;
  }

  Future<void> refreshDashboard() async {
    try {
      await Future.wait([]);
    } catch (e, stackTrace) {
      debugPrint('[DashboardShell] refreshDashboard error: $e');
      debugPrint('$stackTrace');
    }
  }

 
}
