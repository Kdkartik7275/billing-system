import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/theme/app_radius.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../controller/inventory_controller.dart';
import 'status_chip.dart';

/// Desktop-only right-hand panel showing full detail for whichever
/// product is currently selected in [InventoryController.selectedProduct].
class ProductDetailsPanel extends StatelessWidget {
  const ProductDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Obx(() {
        final product = controller.selectedProduct.value;

        if (product == null) {
          return Center(
            child: Text(
              'Select a product to see its details',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          );
        }

        final status = controller.stockStatusFor(product);
        final stockQty = controller.stockQuantityFor(product.id);
        final unit = controller.unitShortCode(product.unitId);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: product.primaryImageUrl != null
                      ? Image.network(
                          product.primaryImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _ImagePlaceholder(colorScheme: colorScheme),
                        )
                      : _ImagePlaceholder(colorScheme: colorScheme),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatusChip(status: status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                product.barcode,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _DetailRow(label: 'Category', value: controller.categoryName(product.categoryId)),
              _DetailRow(label: 'Brand', value: controller.brandName(product.brandId) ?? '—'),
              _DetailRow(
                label: 'Supplier',
                value: controller.supplierName(product.primarySupplierId) ?? '—',
              ),
              const Divider(height: AppSpacing.xxl),
              _DetailRow(
                label: 'Purchase Price',
                value: '₹${product.price.purchasePrice.toStringAsFixed(2)}',
              ),
              _DetailRow(
                label: 'Selling Price',
                value: '₹${product.price.sellingPrice.toStringAsFixed(2)}',
              ),
              _DetailRow(label: 'GST', value: '${product.tax.gstPercent.toStringAsFixed(0)}%'),
              _DetailRow(label: 'Current Stock', value: '${stockQty.toStringAsFixed(0)} $unit'),
              const Divider(height: AppSpacing.xxl),
              _DetailRow(
                label: 'Created',
                value: _formatDate(product.createdAt),
              ),
              if (product.description != null && product.description!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  product.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

const List<String> _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')} ${_monthNames[date.month - 1]} ${date.year}';

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ImagePlaceholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.inventory_2_outlined, size: 40, color: colorScheme.onSurfaceVariant),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5, color: colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
