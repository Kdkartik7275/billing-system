import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/firebase/shop_firebase_service.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInitializerPage extends StatefulWidget {
  final Widget child;

  const AppInitializerPage({super.key, required this.child});

  @override
  State<AppInitializerPage> createState() => _AppInitializerPageState();
}

class _AppInitializerPageState extends State<AppInitializerPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final userController = Get.find<UserController>();

    final route = await userController.checkSession();

    if (!mounted) return;

    if (route != AppRoutes.dashboard) {
      Get.offAllNamed(route);
      return;
    }

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized ||
        !Get.put<ShopFirebaseService>(
          sl<ShopFirebaseService>(),
        ).isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.child;
  }
}
