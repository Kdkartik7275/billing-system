import 'package:billing_system/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/config/routes/app_pages.dart';
import '../core/config/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Retail POS',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.dashboard,

      getPages: AppPages.pages,

      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 600, name: MOBILE),

            Breakpoint(start: 601, end: 1024, name: TABLET),

            Breakpoint(start: 1025, end: 1920, name: DESKTOP),
          ],
        );
      },
    );
  }
}
