import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_binding.dart';
import 'package:billing_system/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_binding.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      binding: DashboardShellBinding(),
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      binding: CartBinding(),
      page: () => const DashboardPage(),
    ),
  ];
}
