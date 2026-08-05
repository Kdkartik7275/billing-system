import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/layout/billing_mobile_layout.dart';
import 'package:billing_system/features/billing/presentation/layout/billing_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BillingController());
    return AdaptiveLayout(
      desktop: Container(),
      tablet: BillingTabletLayout(),
      mobile: BillingMobileLayout(),
    );
  }
}
