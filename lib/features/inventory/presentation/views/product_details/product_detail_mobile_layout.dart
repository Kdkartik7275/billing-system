import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_detail_content.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_detail_header.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailMobileLayout extends StatelessWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailMobileLayout({
    super.key,
    required this.product,
    this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final current = controller.products
          .firstWhere((p) => p.id == product.id, orElse: () => product);
      final currentStock = controller.stockRecords
          .where((s) => s.productId == product.id)
          .firstOrNull;

      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Product Details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') {
                  controller.deleteProduct(current.id);
                  Get.back();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailHeader(product: current, stock: currentStock),
                  const SizedBox(height: 20),
                  ProductDetailContent(product: current, stock: currentStock),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}