import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_detail_content.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_detail_header.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailWebLayout extends StatelessWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailWebLayout({
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(context, controller, current),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ProductDetailHeader(
                              product: current,
                              stock: currentStock,
                              imageSize: 110,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ProductDetailContent(
                              product: current,
                              stock: currentStock,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTopBar(
    BuildContext context,
    InventoryController controller,
    ProductEntity current,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to Inventory',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '·',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.textPlaceholder,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              current.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
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
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}