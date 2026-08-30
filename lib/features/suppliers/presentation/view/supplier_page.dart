import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_mobile_layout.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_tablet_layout.dart';
import 'package:billing_system/features/suppliers/presentation/layout/supplier_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SuppliersController(getSuppliersUsecase: sl(), getPurchasesUsecase: sl()),
    );
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        progressIndicator: circularProgress(context),
        child: AdaptiveLayout(
          mobile: SupplierMobileLayout(),
          tablet: SupplierTabletLayout(),
          desktop: SupplierWebLayout(),
        ),
      ),
    );
  }
}
