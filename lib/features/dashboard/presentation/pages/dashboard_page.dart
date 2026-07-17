import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';

import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_tablet_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_layout.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/pos/presentation/controller/bills_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    //DummyDart.seedProducts(RetailStoreDummyProducts.getDummyProducts());
    Get.put<InventoryController>(
      InventoryController(
        addProductUseCase: sl(),
        getProductsUseCase: sl(),
        refreshProductsUseCase: sl(),
        updateProductUseCase: sl(),
        getMovementLogsUseCase: sl(),
        getStockBatchesUseCase: sl(),
        purchaseStockUseCase: sl(),
      ),
    );
    Get.put<BillsController>(
      BillsController(
        getBillsUseCase: sl(),
        syncBillsUseCase: sl(),
        syncProductsUseCase: sl(),
        getLastSevenDaysSalesUseCase: sl(),
        getPendingBillsUseCase: sl(),
        getProductsByIdsUseCase: sl(),
        sellStockUseCase: sl()
      ),
    );

    return AdaptiveLayout(
      mobile: DashboardMobileLayout(),
      tablet: DashboardTabletLayout(),
      desktop: DashboardWebLayout(),
    );
  }
}
