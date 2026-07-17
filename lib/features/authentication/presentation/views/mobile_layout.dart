import 'package:flutter/material.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/register_shop_link.dart';

class LoginMobileLayout extends StatelessWidget {
  const LoginMobileLayout({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BrandMark(navy: AppColors.primary, amber: Colors.white),
              const SizedBox(height: 32),
              Text('Welcome back', style: textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Sign in to manage today\'s sales and stock.',
                style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 28),
              LoginForm(controller: controller),
              const RegisterShopLink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.navy, required this.amber});
  final Color navy;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.point_of_sale_rounded, color: amber, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'SmartPOS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: navy),
        ),
      ],
    );
  }
}