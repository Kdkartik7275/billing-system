import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailContent({super.key, required this.product, this.stock});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final unit = controller.unitShortCode(product.unitId);
    final status = stock?.statusFor(product.settings.lowStockThreshold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.description != null &&
            product.description!.trim().isNotEmpty) ...[
          Text(
            product.description!,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
        ],
        _SectionLabel('Pricing'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                label: 'Selling Price',
                value: '₹${product.price.sellingPrice.toStringAsFixed(0)}',
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBlock(
                label: 'Purchase Price',
                value: '₹${product.price.purchasePrice.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                label: 'MRP',
                value: product.price.mrp != null
                    ? '₹${product.price.mrp!.toStringAsFixed(0)}'
                    : '—',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBlock(
                label: 'Wholesale Price',
                value: product.price.wholesalePrice != null
                    ? '₹${product.price.wholesalePrice!.toStringAsFixed(0)}'
                    : '—',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                label: 'Profit / Unit',
                value: '₹${product.price.profitPerUnit.toStringAsFixed(0)}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBlock(
                label: 'Margin',
                value: '${product.price.marginPercent.toStringAsFixed(1)}%',
              ),
            ),
          ],
        ),
        if (product.price.discountOffMrpPercent != null) ...[
          const SizedBox(height: 10),
          _StatBlock(
            label: 'Discount off MRP',
            value:
                '${product.price.discountOffMrpPercent!.toStringAsFixed(1)}%',
          ),
        ],
        const SizedBox(height: 20),
        _SectionLabel('Stock'),
        const SizedBox(height: 10),
        if (stock == null)
          Text(
            'No stock record for this product yet',
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
          )
        else ...[
          Row(
            children: [
              if (status != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StatusChip(status: status),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  label: 'On Hand',
                  value: '${stock!.quantity.toStringAsFixed(0)} $unit',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  label: 'Reserved',
                  value: '${stock!.reservedQuantity.toStringAsFixed(0)} $unit',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  label: 'Available',
                  value: '${stock!.availableQuantity.toStringAsFixed(0)} $unit',
                  highlight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Low Stock Alert',
            value: '${product.settings.lowStockThreshold} $unit',
          ),
          _InfoRow(
            label: 'Last Updated',
            value: _formatDate(stock!.lastUpdated),
          ),
        ],
        const SizedBox(height: 20),
        _SectionLabel('Classification'),
        const SizedBox(height: 10),
        _InfoRow(
          label: 'Category',
          value: controller.categoryName(product.categoryId),
        ),
        _InfoRow(
          label: 'Brand',
          value: controller.brandName(product.brandId) ?? '—',
        ),
        _InfoRow(label: 'Unit', value: unit),
        _InfoRow(
          label: 'Supplier',
          value: controller.supplierName(product.primarySupplierId) ?? '—',
        ),
        const SizedBox(height: 20),
        _SectionLabel('Tax & Codes'),
        const SizedBox(height: 10),
        _InfoRow(
          label: 'GST Rate',
          value: '${product.tax.gstPercent.toStringAsFixed(0)}%',
        ),
        _InfoRow(
          label: 'Tax Type',
          value:
              product.tax.type.name[0].toUpperCase() +
              product.tax.type.name.substring(1),
        ),
        _InfoRow(
          label: 'Final Price (incl. tax)',
          value: '₹${product.finalSellingPrice.toStringAsFixed(0)}',
        ),
        _InfoRow(label: 'HSN Code', value: product.tax.hsnCode ?? '—'),
        _InfoRow(
          label: 'Barcode',
          value: product.barcode.isEmpty ? '—' : product.barcode,
        ),
        if (product.variants.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionLabel('Variants'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.variants
                .map(
                  (v) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      v.displayLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 20),
        _SectionLabel('Settings'),
        const SizedBox(height: 10),
        _ToggleRow(label: 'Active', value: product.settings.isActive),
        _ToggleRow(
          label: 'Allow Negative Stock',
          value: product.settings.allowNegativeStock,
        ),
        _ToggleRow(
          label: 'Track Batches',
          value: product.settings.trackBatches,
        ),
        _ToggleRow(label: 'Track Expiry', value: product.settings.trackExpiry),
        _ToggleRow(
          label: 'Loyalty Eligible',
          value: product.settings.isLoyaltyEligible,
        ),
        const SizedBox(height: 20),
        _SectionLabel('Timestamps'),
        const SizedBox(height: 10),
        _InfoRow(label: 'Created', value: _formatDate(product.createdAt)),
        _InfoRow(
          label: 'Last Updated',
          value: product.updatedAt != null
              ? _formatDate(product.updatedAt!)
              : '—',
        ),
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatBlock({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: highlight ? AppColors.primary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;

  const _ToggleRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Icon(
            value ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: value ? const Color(0xFF12B76A) : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
