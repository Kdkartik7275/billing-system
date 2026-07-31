import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_mobile_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_tablet_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddProductController(addProductUseCase: sl()));
    return AdaptiveLayout(
      mobile: AddProductMobileLayout(),
      tablet: AddProductTabletLayout(),
      desktop: AddProductWebLayout(),
    );
  }
}
