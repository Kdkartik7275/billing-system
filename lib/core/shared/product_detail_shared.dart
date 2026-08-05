import 'package:barcode_widget/barcode_widget.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/batch_summary_data.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/detail_section_card.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_gallery.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/purchase_sales_summary.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/quick_action_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/status_pill.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/stock_movement_table.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/purchase_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// =====================================================================
// TAB CONFIG — shared by tablet / web / mobile layouts
// =====================================================================

const List<String> kProductDetailTabs = [
  'Overview',
  'Batches',
  'Movements',
  'Adjustments',
];

const List<IconData> kProductDetailTabIcons = [
  Icons.dashboard_outlined,
  Icons.widgets_outlined,
  Icons.swap_horiz_rounded,
  Icons.tune_rounded,
];

/// Builds the widget list for the currently selected product-detail tab.
/// Used identically by every breakpoint layout.
List<Widget> buildProductDetailTabContent({
  required int tabIndex,
  required List<StockBatchEntity> batches,
  required List<StockMovementEntity> movements,
  required ProductEntity current,
}) {
  switch (tabIndex) {
    case 1:
      return [BatchSummaryTable(batches: batches)];
    case 2:
      return [StockMovementTable(movements: movements)];
    case 3:
      return [
        StockMovementTable(
          title: 'Stock Adjustments',
          movements: movements
              .where((m) => m.type == StockMovementType.adjustment)
              .toList(),
        ),
      ];
    case 0:
    default:
      return [
        BatchSummaryTable(batches: batches, maxRows: 3),
        const SizedBox(height: 14),
        StockMovementTable(movements: movements, maxRows: 5),
        const SizedBox(height: 14),
        PurchaseSalesSummaryRow(
          batches: batches,
          movements: movements,
          sellingPrice: current.price.sellingPrice,
        ),
      ];
  }
}

/// The six quick-action tiles shown on every layout.
List<QuickAction> buildProductQuickActions(ProductEntity product) => [
  QuickAction(
    icon: Icons.add_shopping_cart_outlined,
    color: const Color(0xFF12B76A),
    title: 'Add Purchase',
    subtitle: 'Add new stock',
    onTap: () => showAddPurchaseSheet(Get.context!, product: product),
  ),
  QuickAction(
    icon: Icons.compare_arrows_rounded,
    color: Colors.blue.shade600,
    title: 'Transfer Stock',
    subtitle: 'Move to another warehouse',
    onTap: () {},
  ),
  QuickAction(
    icon: Icons.tune_rounded,
    color: Colors.orange.shade600,
    title: 'Adjust Stock',
    subtitle: 'Adjust quantity',
    onTap: () {},
  ),
  QuickAction(
    icon: Icons.description_outlined,
    color: Colors.purple.shade400,
    title: 'Purchase History',
    subtitle: 'View all purchases',
    onTap: () {},
  ),
  QuickAction(
    icon: Icons.show_chart_rounded,
    color: Colors.blue.shade400,
    title: 'Sales History',
    subtitle: 'View all sales',
    onTap: () {},
  ),
  QuickAction(
    icon: Icons.undo_rounded,
    color: Colors.red.shade400,
    title: 'Returns',
    subtitle: 'View returns',
    onTap: () {},
  ),
];

// =====================================================================
// STOCK SUMMARY — totalQty / reservedQty / warehouseName / unit
// =====================================================================

class ProductStockSummary {
  final double totalQty;
  final double reservedQty;
  final String warehouseName;
  final String unit;

  const ProductStockSummary({
    required this.totalQty,
    required this.reservedQty,
    required this.warehouseName,
    required this.unit,
  });
}

ProductStockSummary computeProductStockSummary({
  required InventoryController controller,
  required ProductEntity product,
  required StockEntity? fallbackStock,
}) {
  final records = controller.stockRecords
      .where((s) => s.productId == product.id)
      .toList();

  final totalQty = records.isNotEmpty
      ? records.fold<double>(0, (sum, s) => sum + s.quantity)
      : (fallbackStock?.quantity ?? 0);

  final reservedQty = records.fold<double>(
    0,
    (sum, s) => sum + s.reservedQuantity,
  );

  final warehouseName = records.isNotEmpty
      ? records.first.warehouseId
      : 'Main Warehouse';

  return ProductStockSummary(
    totalQty: totalQty,
    reservedQty: reservedQty,
    warehouseName: warehouseName,
    unit: controller.unitShortCode(product.unitId),
  );
}

// =====================================================================
// PRODUCT INFO CARD — gallery, name/status, sku/barcode, chips, prices
// =====================================================================

class ProductInfoCard extends StatelessWidget {
  final ProductEntity product;
  final InventoryController controller;

  const ProductInfoCard({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return DetailSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductGallery(imageUrls: product.images.map((e) => e.url).toList()),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              StatusPill(
                label: product.settings.isActive ? 'Active' : 'Inactive',
                color: product.settings.isActive
                    ? const Color(0xFF12B76A)
                    : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'SKU: ${product.sku}',
            style: tt.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            'Barcode: ${product.barcode.isEmpty ? '—' : product.barcode}',
            style: tt.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: product.barcode,
                width: 220,
                height: 70,
                drawText: false,
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.print,
                  size: 18,
                  color: AppColors.primary,
                ),
                onPressed: () async => await printBarcode(product.barcode),
                label: Text(
                  'Print',
                  style: tt.titleSmall!.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ProductInfoChip(
                label: 'Brand: ${controller.brandName(product.brandId) ?? '—'}',
              ),
              ProductInfoChip(
                label:
                    'Category: ${controller.categoryName(product.categoryId)}',
              ),
            ],
          ),
          if (product.description != null &&
              product.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              product.description!,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ProductPriceTile(
                  label: 'Selling Price',
                  value: '₹${product.price.sellingPrice.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: ProductPriceTile(
                  label: 'Cost Price',
                  value: '₹${product.price.purchasePrice.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductInfoChip extends StatelessWidget {
  final String label;

  const ProductInfoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProductPriceTile extends StatelessWidget {
  final String label;
  final String value;

  const ProductPriceTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
