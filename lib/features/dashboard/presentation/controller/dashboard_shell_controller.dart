import 'package:get/get.dart';

import '../models/dashboard_menu.dart';

class DashboardShellController extends GetxController {
  final selectedMenu = DashboardMenu.dashboard.obs;

  void changeMenu(DashboardMenu menu) {
    selectedMenu.value = menu;
  }
}
