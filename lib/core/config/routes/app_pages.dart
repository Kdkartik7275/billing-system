import 'package:billing_system/app/app.dart';
import 'package:billing_system/app_initializer.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_binding.dart';
import 'package:billing_system/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:billing_system/features/authentication/presentation/views/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      binding: DashboardShellBinding(),
      page: () =>kIsWeb ? AppInitializerPage(child: const DashboardPage()) : const DashboardPage(),
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return const RouteSettings(name: AppRoutes.splash);
  }
}
