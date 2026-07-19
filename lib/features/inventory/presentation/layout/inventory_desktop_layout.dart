import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/inventory_stat_card.dart';
import '../widgets/inventory_filter_bar.dart';
import '../widgets/inventory_data_table.dart';

class InventoryDesktopLayout extends StatelessWidget {
  const InventoryDesktopLayout({super.key});

  static final BoxDecoration _filterBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return RefreshIndicator(
      onRefresh: () async => await controller.refreshProducts(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RepaintBoundary(child: _InventoryStatsRow()),
            const SizedBox(height: 20),

            RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: _filterBarDecoration,
                child: const InventoryFilterBar(),
              ),
            ),
            const SizedBox(height: 20),

            const RepaintBoundary(child: InventoryDataTable()),
          ],
        ),
      ),
    );
  }
}

class _InventoryStatsRow extends StatelessWidget {
  const _InventoryStatsRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final products = controller.products;

      var total = 0;
      var totalValue = 0.0;
      var lowStock = 0;
      final categorySet = <String>{};

      for (final p in products) {
        total++;
        totalValue += p.totalValue;
        if (p.status == StockStatus.lowStock) lowStock++;
        categorySet.add(p.category);
      }
      final categories = categorySet.length;

      return Row(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: InventoryStatCard(
                title: 'Total Products',
                value: '$total',
                icon: Icons.inventory_2_outlined,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RepaintBoundary(
              child: InventoryStatCard(
                title: 'Total Value',
                value: '₹${_formatNumber(totalValue)}',
                icon: Icons.currency_rupee_rounded,
                valueColor: AppColors.primary,
                iconBgColor: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RepaintBoundary(
              child: InventoryStatCard(
                title: 'Low Stock',
                value: '$lowStock',
                icon: Icons.warning_amber_rounded,
                valueColor: Colors.orange.shade700,
                iconBgColor: Colors.orange.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RepaintBoundary(
              child: InventoryStatCard(
                title: 'Categories',
                value: '$categories',
                icon: Icons.category_outlined,
                valueColor: Colors.purple.shade600,
                iconBgColor: Colors.purple.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      );
    });
  }
}

String _formatNumber(double value) {
  if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
