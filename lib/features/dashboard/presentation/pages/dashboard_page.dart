import 'package:billing_system/core/config/responsive/adaptive_layout.dart';

import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_tablet_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_layout.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billing_system/core/di/init_dependencies.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      InventoryController(
        getProductsUseCase: sl(),
        getCategoriesUsecase: sl(),
        getStocksUsecase: sl(),
        getBrandsUsecase: sl(),
      ),
    );

    return AdaptiveLayout(
      mobile: DashboardMobileLayout(),
      tablet: DashboardTabletLayout(),
      desktop: DashboardWebLayout(),
    );
  }
}
