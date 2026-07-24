import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(controller: controller),
              const SizedBox(height: AppSpacing.xxl),
              RepaintBoundary(child: const _StatsRow()),
              const SizedBox(height: AppSpacing.xl),
              const InventoryFilterBar(),
              const SizedBox(height: AppSpacing.xl),
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
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                '${controller.totalProductsCount} products across your catalog',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton.filledTonal(
          tooltip: 'Refresh',
          onPressed: controller.refreshProducts,
          style: IconButton.styleFrom(backgroundColor: AppColors.primary),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: controller.exportProducts,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white, // Icon + Text color
            side: BorderSide(color: AppColors.primary),
          ),
          icon: const Icon(Icons.upload_rounded, size: 18),
          label: const Text('Export'),
        ),
        const SizedBox(width: AppSpacing.md),
        FilledButton.icon(
          onPressed: () {
            Get.snackbar(
              'Add Product',
              'The add-product form will be available soon.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: Text(
            'Add Product',
            style: textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(
      () => Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 3),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _MetricTile(
                icon: Icons.inventory_2_outlined,
                iconColor: AppColors.primary,
                title: "Products",
                value: "${controller.totalProductsCount}",
              ),
            ),
            _divider(),

            Expanded(
              child: _MetricTile(
                icon: Icons.currency_rupee_rounded,
                iconColor: Colors.green,
                title: "Value",
                value: "₹${_formatCompact(controller.totalInventoryValue)}",
              ),
            ),
            _divider(),

            Expanded(
              child: _MetricTile(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.orange,
                title: "Low Stock",
                value: "${controller.lowStockCount}",
              ),
            ),
            _divider(),

            Expanded(
              child: _MetricTile(
                icon: Icons.remove_shopping_cart_outlined,
                iconColor: Colors.red,
                title: "Out of Stock",
                value: "${controller.outOfStockCount}",
              ),
            ),
            _divider(),

            Expanded(
              child: _MetricTile(
                icon: Icons.fiber_new_rounded,
                iconColor: Colors.purple,
                title: "Today",
                value: "${controller.todaysAddedCount}",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.grey.withValues(alpha: .2),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
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
