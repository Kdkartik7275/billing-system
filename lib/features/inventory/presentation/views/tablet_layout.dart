import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_page.dart';
import 'package:billing_system/features/inventory/presentation/widgets/inventory_header_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/inventory_stat_panel.dart';
import 'package:billing_system/features/inventory/presentation/widgets/inventory_data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../widgets/inventory_filter_bar.dart';

class InventoryTabletLayout extends StatelessWidget {
  const InventoryTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(
      () => controller.isLoading.value
          ? circularProgress(context)
          : LoadingOverlay(
              isLoading: controller.isLoading.value || controller.deleting.value,
              progressIndicator: circularProgress(context),
              color: Colors.black.withValues(alpha: 0.3),
              child: RefreshIndicator(
                onRefresh: () => controller.refreshProducts(),
                backgroundColor: Colors.white,
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  children: [
                    const SizedBox(height: 10),
                    Obx(
                      () => InventoryHeaderBar(
                        title: 'Inventory',
                        subtitle: '${controller.totalProductsCount} products',
                        onRefresh: () => controller.refreshProducts(),
                        onAddProduct: () async {
                          final result =
                              await Get.to<(ProductEntity, StockEntity)>(
                                () => AddProductPage(),
                              );

                          if (result != null) {
                            final product = result.$1;
                            final stock = result.$2;
                            controller.products.insert(0, product);
                            controller.stockRecords.insert(0, stock);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(
                      () => InventoryStatsPanel(
                        items: [
                          InventoryStatItem(
                            title: 'Total Products',
                            value: '${controller.totalProductsCount}',
                            icon: Icons.inventory_2_outlined,
                            color: AppColors.primary,
                          ),
                          InventoryStatItem(
                            title: 'Inventory Value',
                            value: '₹${_fmt(controller.totalInventoryValue)}',
                            icon: Icons.currency_rupee_rounded,
                            color: Colors.green.shade600,
                          ),
                          InventoryStatItem(
                            title: 'Low Stock',
                            value: '${controller.lowStockCount}',
                            icon: Icons.warning_amber_rounded,
                            color: Colors.orange.shade700,
                          ),
                          InventoryStatItem(
                            title: 'Categories',
                            value: '${controller.categories.length}',
                            icon: Icons.category_outlined,
                            color: Colors.purple.shade600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Filter bar (compact stacked version) ─────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const InventoryFilterBar(isCompact: true),
                    ),
                    const SizedBox(height: 18),

                    // ── Product table ─────────────────────────────────────
                    InventoryDataTable(
                      onDelete: (product) =>
                          controller.deleteProduct(product.id),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
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
