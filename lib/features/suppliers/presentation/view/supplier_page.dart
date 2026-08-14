import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_mobile_layout.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_tablet_layout.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_web_layout.dart';
import 'package:flutter/material.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobile: SupplierMobileLayout(),
      tablet: SupplierTabletLayout(),
      desktop: SupplierWebLayout(),
    );
  }
}
