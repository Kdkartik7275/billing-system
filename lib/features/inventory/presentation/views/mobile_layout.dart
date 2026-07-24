import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../widgets/inventory_filter_bar.dart';

class InventoryMobileLayout extends StatelessWidget {
  InventoryMobileLayout({super.key});

  final InventoryController controller = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LoadingOverlay(
          isLoading: controller.isLoading.value,
          progressIndicator: circularProgress(context),
          color: Colors.black.withValues(alpha: .3),
          child: RefreshIndicator(
            onRefresh: controller.refreshProducts,
            color: AppColors.primary,
            backgroundColor: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                /// Stats
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.9,
                  children: [
                    _MobileStatCard(
                      title: 'Total Products',
                      value: '${controller.totalProductsCount}',
                      icon: Icons.inventory_2_outlined,
                    ),
                    _MobileStatCard(
                      title: 'Inventory Value',
                      value: '₹${_fmt(controller.totalInventoryValue)}',
                      icon: Icons.currency_rupee_rounded,
                      valueColor: AppColors.primary,
                    ),
                    _MobileStatCard(
                      title: 'Low Stock',
                      value: '${controller.lowStockCount}',
                      icon: Icons.warning_amber_rounded,
                      valueColor: Colors.orange.shade700,
                    ),
                    _MobileStatCard(
                      title: 'Categories',
                      value: '${controller.categories.length}',
                      icon: Icons.category_outlined,
                      valueColor: Colors.purple.shade600,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// Filters
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const InventoryFilterBar(isCompact: true),
                ),

                const SizedBox(height: 18),

                /// Header
                Text(
                  'Products (${controller.filteredProducts.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                /// Products
                if (controller.filteredProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => _MobileProductCard(
                      product: controller.filteredProducts[index],
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _MobileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _MobileStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = valueColor ?? Colors.grey.shade900;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}

class _MobileProductCard extends StatelessWidget {
  final ProductEntity product;

  const _MobileProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return GestureDetector(
      // onTap: () => Get.to(() => ProductDetailPage(product: product)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 52,
                height: 52,
                child: product.primaryImageUrl != null
                    ? Image.network(
                        product.primaryImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${controller.categoryName(product.categoryId)} · ${controller.stockQuantityFor(product.id).toStringAsFixed(0)} ${controller.unitShortCode(product.unitId)}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // StockStatusBadge(status: product.status),
                ],
              ),
            ),

            // Popup menu
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') controller.deleteProduct(product.id);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              icon: Icon(
                Icons.more_vert_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _fmt(double value) {
  if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
