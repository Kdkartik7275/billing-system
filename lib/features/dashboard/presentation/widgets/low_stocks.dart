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
        final lowStockItems = controller.lowStockProducts;
        final hasLowStock = lowStockItems.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Low Stock Alerts', style: tt.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hasLowStock
                        ? Colors.red.withValues(alpha: 0.08)
                        : Colors.amber.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${lowStockItems.length} Item${lowStockItems.length == 1 ? '' : 's'}',
                    style: tt.bodySmall?.copyWith(
                      color: hasLowStock ? Colors.red : Colors.orange,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (!hasLowStock)
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
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: lowStockItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = lowStockItems[index];
                  return _LowStockTile(product: product);
                },
              ),
          ],
        );
      }),
    );
  }
}

class _LowStockTile extends GetView<InventoryController> {
  const _LowStockTile({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color:
                  controller.stockStatusFor(product) == StockStatus.outOfStock
                  ? Colors.red
                  : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Product info
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
                Text(
                  'SKU: ${product.sku} · ${controller.categoryName(product.categoryId)}',
                  style: tt.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Stock count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  controller.stockStatusFor(product) == StockStatus.outOfStock
                  ? Colors.red.withValues(alpha: 0.08)
                  : Colors.orange.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.stockQuantityFor(product.id).toInt()} ${controller.unitName(product.unitId)}',
              style: tt.bodySmall?.copyWith(
                color:
                    controller.stockStatusFor(product) == StockStatus.outOfStock
                    ? Colors.red
                    : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}