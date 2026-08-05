import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/product_detail_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/product_details/product_detail_mobile_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/product_details/product_detail_tablet_layout.dart';
import 'package:billing_system/features/inventory/presentation/views/product_details/product_detail_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailPage({super.key, required this.product, this.stock});

  @override
  Widget build(BuildContext context) {
    Get.put(
      ProductDetailController(
        getProductStockBatchesUsecase: sl(),
        getProductStockMovementsUsecase: sl(),
        productId: product.id,
      ),
    );
    return AdaptiveLayout(
      mobile: ProductDetailMobileLayout(product: product, stock: stock),
      tablet: ProductDetailTabletLayout(product: product, stock: stock),
      desktop: ProductDetailWebLayout(product: product, stock: stock),
    );
  }
}
