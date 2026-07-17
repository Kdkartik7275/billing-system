import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/authentication/presentation/views/register_shop_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegisterShopLink extends StatelessWidget {
  const RegisterShopLink({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodyMedium?.copyWith(color: Colors.black,fontSize: 15),
            children: [
              const TextSpan(text: "New to SmartPOS? "),
              TextSpan(
                text: 'Register your shop',
                style: Theme.of(  context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.to(() => const RegisterShopPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}