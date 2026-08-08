import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/billing/presentation/layout/billing_mobile_layout.dart';
import 'package:billing_system/features/billing/presentation/layout/billing_tablet_layout.dart';
import 'package:billing_system/features/billing/presentation/layout/billing_web_layout.dart';
import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      desktop: BillingWebLayout(),
      tablet: BillingTabletLayout(),
      mobile: BillingMobileLayout(),
    );
  }
}
