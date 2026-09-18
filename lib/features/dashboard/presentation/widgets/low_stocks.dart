import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LowStockAlerts extends StatelessWidget {
  const LowStockAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final controller = Get.find<InventoryController>();

    return ChartCard(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final outOfStockItems = controller.products
            .where(
              (p) => controller.stockStatusFor(p) == StockStatus.outOfStock,
            )
            .toList();
        final lowStockItems = controller.lowStockProducts;

        // Out of stock first — it's the more urgent state.
        final combined = [...outOfStockItems, ...lowStockItems];
        final hasIssues = combined.isNotEmpty;
        final previewItems = combined.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 18,
                      color: hasIssues ? Colors.red : Colors.amber.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text('Stock Alerts', style: tt.titleMedium),
                  ],
                ),
                if (hasIssues)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (outOfStockItems.isNotEmpty) ...[
                        _CountPill(
                          count: outOfStockItems.length,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 6),
                      ],
                      if (lowStockItems.isNotEmpty)
                        _CountPill(
                          count: lowStockItems.length,
                          color: Colors.orange,
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (!hasIssues)
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'All stocks are sufficient',
                    style: tt.bodyMedium?.copyWith(
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: previewItems.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = previewItems[index];
                  return _StockAlertTile(product: product);
                },
              ),
              if (combined.length > previewItems.length) ...[
                const SizedBox(height: 4),
                Center(
                  child: TextButton.icon(
                    onPressed: () =>
                        _showStockAlertsSheet(context, controller, combined),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Text('View All'),
                    label: const Icon(Icons.arrow_forward_rounded, size: 16),
                  ),
                ),
              ],
            ],
          ],
        );
      }),
    );
  }

  void _showStockAlertsSheet(
    BuildContext context,
    InventoryController controller,
    List<ProductEntity> combined,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final tt = Theme.of(sheetContext).textTheme;
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text('Stock Alerts', style: tt.titleMedium),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${combined.length} Item${combined.length == 1 ? '' : 's'}',
                            style: tt.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      itemCount: combined.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = combined[index];
                        return _StockAlertTile(product: product);
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;
  final Color color;

  const _CountPill({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StockAlertTile extends GetView<InventoryController> {
  const _StockAlertTile({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isOutOfStock =
        controller.stockStatusFor(product) == StockStatus.outOfStock;
    final statusColor = isOutOfStock ? Colors.red : Colors.orange;
    final statusLabel = isOutOfStock ? 'Out of Stock' : 'Low Stock';

    return GestureDetector(
      onTap: () => controller.selectProduct(product),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusLabel,
                          style: tt.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'SKU: ${product.sku} · ${controller.categoryName(product.categoryId)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isOutOfStock
                    ? '0 ${controller.unitName(product.unitId)}'
                    : '${controller.stockQuantityFor(product.id).toInt()} ${controller.unitName(product.unitId)}',
                style: tt.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
