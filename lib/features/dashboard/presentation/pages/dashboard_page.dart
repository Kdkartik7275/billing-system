import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_tablet_layout.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_layout.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late InventoryController inventoryController;
  late BillingController billingController;

  @override
  void initState() {
    super.initState();
    inventoryController = Get.put(
      InventoryController(
        getProductsUseCase: sl(),
        getCategoriesUsecase: sl(),
        getStocksUsecase: sl(),
        getBrandsUsecase: sl(),
        getUnitsUsecase: sl(),
        deleteProductUseCase: sl(),
        getSuppliersUsecase: sl(),
      ),
    );
    billingController = Get.put(
      BillingController(
        getBillsByDateRangeUsecase: sl(),
        syncPendingBillsUsecase: sl(),
        getUnsyncedBillsUsecase: sl(),
        aggregateSoldQuantitiesUsecase: sl(),
        reduceStockForSoldProductsUsecase: sl(),
        billSyncScheduler: sl(),
      ),
    );
    Get.put(
      CartController(
        getAvailableStock: (productId) =>
            inventoryController.stockQuantityFor(productId).toInt(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: billingController.syncing.value,
        progressIndicator: circularProgress(context),
        color: Colors.black38,
        child: AdaptiveLayout(
          mobile: DashboardMobileLayout(),
          tablet: DashboardTabletLayout(),
          desktop: DashboardWebLayout(),
        ),
      ),
    );
  }
}
