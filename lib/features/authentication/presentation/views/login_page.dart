import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/authentication/presentation/views/mobile_layout.dart';
import 'package:billing_system/features/authentication/presentation/views/tablet_layout.dart';
import 'package:billing_system/features/authentication/presentation/views/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<LoginController>(LoginController(loginUserUseCase: sl()));

    return AdaptiveLayout(
      mobile: const LoginMobileLayout(),
      tablet: const LoginTabletLayout(),
      desktop: const LoginWebLayout(),
    );
  }
}