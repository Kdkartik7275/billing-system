import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/layouts/sales_mobile_layout.dart';
import 'package:billing_system/features/sales/presentation/layouts/sales_tablet_layout.dart';
import 'package:billing_system/features/sales/presentation/layouts/sales_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SalesController(getBillsByDateUsecase: sl()));
    return AdaptiveLayout(
      mobile: SalesMobileLayout(),
      tablet: SalesTabletLayout(),
      desktop: SalesWebLayout(),
    );
  }
}
