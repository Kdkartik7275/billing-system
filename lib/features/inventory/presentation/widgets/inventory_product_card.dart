import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/theme/app_radius.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/inventory_controller.dart';
import 'status_chip.dart';

/// Card representation of a product, used by the mobile layout in place
/// of the desktop/tablet [InventoryDataTable].
class InventoryProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InventoryProductCard({
    super.key,
    required this.product,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final colorScheme = Theme.of(context).colorScheme;
    final status = controller.stockStatusFor(product);
    final stockQty = controller.stockQuantityFor(product.id);
    final unit = controller.unitShortCode(product.unitId);

    return InkWell(
      onTap: onView,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: product.primaryImageUrl != null
                        ? Image.network(
                            product.primaryImageUrl!,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            cacheWidth: 112,
                            cacheHeight: 112,
                            errorBuilder: (_, __, ___) =>
                                _placeholder(colorScheme),
                          )
                        : _placeholder(colorScheme),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.barcode,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case 'view':
                        onView?.call();
                        break;
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'view', child: Text('View')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                _Tag(label: controller.categoryName(product.categoryId)),
                if (controller.brandName(product.brandId) != null)
                  _Tag(label: controller.brandName(product.brandId)!),
                if (controller.supplierName(product.primarySupplierId) != null)
                  _Tag(
                    label: controller.supplierName(product.primarySupplierId)!,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _MetricColumn(
                  label: 'Selling',
                  value: '₹${product.price.sellingPrice.toStringAsFixed(0)}',
                  valueColor: colorScheme.primary,
                ),
                _MetricColumn(
                  label: 'Purchase',
                  value: '₹${product.price.purchasePrice.toStringAsFixed(0)}',
                ),
                _MetricColumn(
                  label: 'Stock',
                  value: '${stockQty.toStringAsFixed(0)} $unit',
                ),
                StatusChip(status: status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) => Container(
    color: colorScheme.surfaceContainerHighest,
    alignment: Alignment.center,
    child: Icon(
      Icons.inventory_2_outlined,
      size: 22,
      color: colorScheme.onSurfaceVariant,
    ),
  );
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricColumn({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
