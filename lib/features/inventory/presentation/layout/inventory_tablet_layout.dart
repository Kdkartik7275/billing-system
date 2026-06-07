import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../widgets/inventory_stat_card.dart';
import '../widgets/inventory_filter_bar.dart';
import '../widgets/inventory_card_list.dart';

class InventoryTabletLayout extends StatelessWidget {
  const InventoryTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

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
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── 2×2 Stat grid ────────────────────────────────────
                    Obx(
                      () => GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3.2,
                        children: [
                          InventoryStatCard(
                            title: 'Total Products',
                            value: '${controller.totalProducts}',
                            icon: Icons.inventory_2_outlined,
                          ),
                          InventoryStatCard(
                            title: 'Total Value',
                            value: '₹${_formatNumber(controller.totalValue)}',
                            icon: Icons.currency_rupee_rounded,
                            valueColor: AppColors.primary,
                            iconBgColor: AppColors.primary.withValues(
                              alpha: 0.08,
                            ),
                          ),
                          InventoryStatCard(
                            title: 'Low Stock',
                            value: '${controller.lowStockCount}',
                            icon: Icons.warning_amber_rounded,
                            valueColor: Colors.orange.shade700,
                            iconBgColor: Colors.orange.withValues(alpha: 0.08),
                          ),
                          InventoryStatCard(
                            title: 'Categories',
                            value: '${controller.categoryCount}',
                            icon: Icons.category_outlined,
                            valueColor: Colors.purple.shade600,
                            iconBgColor: Colors.purple.withValues(alpha: 0.08),
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
                      child: const InventoryFilterBar(compact: true),
                    ),
                    const SizedBox(height: 16),

                    // ── Card list ─────────────────────────────────────────
                    const InventoryCardList(),
                  ],
                ),
              ),
            ),
    );
  }
}

String _formatNumber(double value) {
  if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
