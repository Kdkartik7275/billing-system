import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/theme/app_spacing.dart';
import '../controller/inventory_controller.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/inventory_data_table.dart';
import '../widgets/inventory_filter_bar.dart';
import '../widgets/inventory_stat_card.dart';
import '../widgets/loading_widget.dart';

class InventoryTabletLayout extends StatelessWidget {
  const InventoryTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(controller: controller),
              const SizedBox(height: AppSpacing.lg),
              const _StatsWrap(),
              const SizedBox(height: AppSpacing.md),
              const InventoryFilterBar(),
              const SizedBox(height: AppSpacing.md),
              Expanded(child: _MainTableArea(controller: controller)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final InventoryController controller;

  const _HeaderRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  '${controller.totalProductsCount} products',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              height: 36,
              width: 36,
              child: IconButton.filledTonal(
                tooltip: 'Refresh',
                onPressed: controller.refreshProducts,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.refresh_rounded, size: 17),
              ),
            ),
            SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                onPressed: controller.exportProducts,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.upload_rounded, size: 15),
                label: const Text('Export'),
              ),
            ),
            SizedBox(
              height: 36,
              child: FilledButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Add Product',
                    'The add-product form will be available soon.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 15),
                label: const Text('Add Product'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsWrap extends StatelessWidget {
  const _StatsWrap();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(
      () => LayoutBuilder(
        builder: (context, constraints) {
          // 3 cards per row minimum, but never narrower than ~180px each.
          final cardWidth = (constraints.maxWidth - AppSpacing.md * 2) / 3;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              SizedBox(
                width: cardWidth,
                child: InventoryStatCard(
                  title: 'Total Products',
                  value: '${controller.totalProductsCount}',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: InventoryStatCard(
                  title: 'Inventory Value',
                  value: '₹${_formatCompact(controller.totalInventoryValue)}',
                  icon: Icons.currency_rupee_rounded,
                  accent: AppColors.primary,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: InventoryStatCard(
                  title: 'Low Stock',
                  value: '${controller.lowStockCount}',
                  icon: Icons.warning_amber_rounded,
                  accent: AppColors.warning,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: InventoryStatCard(
                  title: 'Out of Stock',
                  value: '${controller.outOfStockCount}',
                  icon: Icons.remove_shopping_cart_outlined,
                  accent: AppColors.error,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: InventoryStatCard(
                  title: "Today's Added",
                  value: '${controller.todaysAddedCount}',
                  icon: Icons.fiber_new_rounded,
                  accent: AppColors.secondary,
                ),
              ),
            ],
          );
        },
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
      if (controller.isLoading.value) {
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

      return InventoryDataTable(
        //  minWidth: 900,
        onDelete: (product) {
          showDialog(
            context: context,
            builder: (_) => DeleteDialog(
              itemName: product.name,
              onConfirm: () => controller.deleteProduct(product.id),
            ),
          );
        },
      );
    });
  }
}

String _formatCompact(double value) {
  if (value >= 10000000) return '${(value / 10000000).toStringAsFixed(2)}Cr';
  if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
