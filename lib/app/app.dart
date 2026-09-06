import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_theme.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
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
      title: 'SmartPOS',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.splash,
      unknownRoute: GetPage(name: '/notfound', page: () => const SplashPage()),

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

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final UserController _userController;

  @override
  void initState() {
    super.initState();

    _userController = Get.find<UserController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AnalyticsService.logEvent('splash_view');

      await Future.delayed(const Duration(milliseconds: 500));

      final route = await _userController.checkSession();

      if (!mounted) return;

      await AnalyticsService.logEvent(
        'session_check_complete',
        parameters: {'next_route': route},
      );

      Get.offAllNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Obx(
          () => Center(
            child: Column(
              children: [
                const Spacer(),

                // Logo Container
                Image.asset(
                  "assets/images/pos.png",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * .5,
                ),

                const SizedBox(height: 30),

                const Spacer(),

                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _userController.statusMessage.value,
                    key: ValueKey(_userController.statusMessage.value),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Version 1.0.0",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(192),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
