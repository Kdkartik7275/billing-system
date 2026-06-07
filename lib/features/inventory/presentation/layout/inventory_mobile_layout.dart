import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../widgets/inventory_filter_bar.dart';
import '../widgets/stock_status_badge.dart';

class InventoryMobileLayout extends StatefulWidget {
  const InventoryMobileLayout({super.key});

  @override
  State<InventoryMobileLayout> createState() => _InventoryMobileLayoutState();
}

class _InventoryMobileLayoutState extends State<InventoryMobileLayout> {
  final controller = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.value
          ? circularProgress(context)
          : LoadingOverlay(
              isLoading: controller.addingNewProduct.value,
              progressIndicator: circularProgress(context),
              color: Colors.black.withValues(alpha: 0.3),
              child: RefreshIndicator(
                onRefresh: () => controller.refreshProducts(),
                backgroundColor: Colors.white,
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.all(14),

                  children: [
                    // ── Stat cards 2×2 grid ──────────────────────────────
                    Obx(
                      () => GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.9,
                        children: [
                          _MobileStatCard(
                            title: 'Total Products',
                            value: '${controller.totalProducts}',
                            icon: Icons.inventory_2_outlined,
                          ),
                          _MobileStatCard(
                            title: 'Total Value',
                            value: '₹${_fmt(controller.totalValue)}',
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
                            value: '${controller.categoryCount}',
                            icon: Icons.category_outlined,
                            valueColor: Colors.purple.shade600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Filter bar ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const InventoryFilterBar(compact: true),
                    ),
                    const SizedBox(height: 16),

                    // ── Product list header ──────────────────────────────
                    Obx(
                      () => Text(
                        'Products (${controller.filteredProducts.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Product list ─────────────────────────────────────
                    Obx(() {
                      final products = controller.filteredProducts;
                      if (products.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'No products found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            _MobileProductCard(product: products[i]),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
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
  final InventoryProduct product;

  const _MobileProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailPage(product: product)),

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
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                    ),
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
                    '${product.category} · ${product.stock} ${product.stockUnit}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StockStatusBadge(status: product.status),
                    ],
                  ),
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
