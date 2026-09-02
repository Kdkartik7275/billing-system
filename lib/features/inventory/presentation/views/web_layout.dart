import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/add_product_page.dart';
import 'package:billing_system/features/inventory/presentation/widgets/inventory_header_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/inventory_stat_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../core/config/theme/app_spacing.dart';
import '../controller/inventory_controller.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/inventory_data_table.dart';
import '../widgets/inventory_filter_bar.dart';
import '../widgets/loading_widget.dart';

class InventoryWebLayout extends StatelessWidget {
  const InventoryWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading,
         progressIndicator: circularProgress(context),
            color: Colors.black.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => InventoryHeaderBar(
                    title: 'Inventory',
                    subtitle: '${controller.totalProductsCount} products',
                    onRefresh: () => controller.refreshProducts(),
                    onExport: controller.exportProducts,
                    isExporting: controller.exporting.value,
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
                const SizedBox(height: AppSpacing.xxl),
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
                const SizedBox(height: AppSpacing.xl),
                const InventoryFilterBar(),
                const SizedBox(height: AppSpacing.xl),
                Expanded(child: _MainTableArea(controller: controller)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainTableArea extends StatelessWidget {
  final InventoryController controller;

  const _MainTableArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const LoadingWidget();
      }

      if (controller.filteredProducts.isEmpty) {
        return EmptyState(
          title: 'No products found',
          message: 'Try adjusting your search or filters.',
          onClear: () {
            controller.clearSearch();
            controller.selectCategory('All');
            controller.selectBrand('All');
            controller.selectSupplier('All');
            controller.selectStockFilter(StockFilter.all);
          },
        );
      }

      return SizedBox(
        width: double.infinity,
        child: InventoryDataTable(
          onDelete: (product) {
            showDialog(
              context: context,
              builder: (_) => DeleteDialog(
                itemName: product.name,
                onConfirm: () => controller.deleteProduct(product.id),
              ),
            );
          },
        ),
      );
    });
  }
}

String _fmt(double value) {
  if (value >= 10000000) return '${(value / 10000000).toStringAsFixed(2)}Cr';
  if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}