import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_mobile_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_tablet_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductPage extends StatelessWidget {
  final ProductEntity product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    Get.put(
      AddProductController(
        addProductUseCase: sl(),
        updateProductUseCase: sl(),
        initialProduct: product.copyWith(
          categoryId: inventoryController.categoryName(product.categoryId),
          brandId: inventoryController.brandName(product.brandId),
          unitId: inventoryController.unitName(product.unitId),
          primarySupplierId: inventoryController.supplierName(
            product.primarySupplierId,
          ),
        ),
        initialStockEntry: inventoryController.stockRecords.firstWhere(
          (stock) => stock.productId == product.id,
        ),
      ),
    );

    return AdaptiveLayout(
      mobile: AddProductMobileLayout(),
      tablet: AddProductTabletLayout(),
      desktop: AddProductWebLayout(),
    );
  }
}
