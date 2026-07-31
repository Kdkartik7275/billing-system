import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/presentation/views/mobile_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/inventory_controller.dart';

import 'web_layout.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

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
      mobile: InventoryMobileLayout(),
      tablet: InventoryTabletLayout(),
      desktop: InventoryWebLayout(),
    );
  }
}
