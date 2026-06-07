import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:billing_system/features/pos/presentation/layout/pos_mobile_layout.dart';
import 'package:billing_system/features/pos/presentation/layout/pos_tablet_layout.dart';
import 'package:billing_system/features/pos/presentation/layout/pos_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class POSBillingPage extends StatelessWidget {
  const POSBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<CartController>(CartController(), permanent: false);

    return AdaptiveLayout(
      mobile: const PosMobileLayout(),
      tablet: const PosTabletLayout(),
      desktop: const PosWebLayout(),
    );
  }
}