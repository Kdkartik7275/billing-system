import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/extensions/inventory_product_x.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/info_card.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/info_row.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/quick_stat.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/stock_batches_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewTab extends GetView<InventoryController> {
  final InventoryProduct product;
  final List<StockBatch> batches;
  final String Function(double) fmt;

  const OverviewTab({
    super.key,
    required this.product,
    required this.batches,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final stock = batches.fold<double>(0, (sum, batch) => sum + batch.quantityRemaining);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        Row(
          children: [
            QuickStat(
              label: 'Purchase Price',
              value: fmt(p.purchasePrice),
              icon: Icons.currency_rupee_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            QuickStat(
              label: 'Stock',
              value: '${stock.toInt()} ${p.stockUnit}',
              icon: Icons.inventory_outlined,
              color: p.statusColor,
            ),
            const SizedBox(width: 10),
            QuickStat(
              label: 'Total Value',
              value: fmt(controller.totalStockValue()),
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.purple.shade600,
            ),
          ],
        ),
        const SizedBox(height: 14),
        InfoCard(
          title: 'Product Information',
          icon: Icons.info_outline_rounded,
          rows: [
            InfoRow('SKU', p.sku),
            InfoRow('Barcode', p.barcode),
            InfoRow('Category', p.category),
            InfoRow('Supplier', p.supplier),
            InfoRow('Stock Unit', p.stockUnit),
          ],
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Stock',
          icon: Icons.local_offer_outlined,
          rows: [
            InfoRow('Current Stock', '${stock.toInt()} ${p.stockUnit}'),
            InfoRow('Total Stock Value', fmt(controller.totalStockValue())),
            InfoRow('Stock Status', p.statusLabel, valueColor: p.statusColor),
          ],
        ),
        const SizedBox(height: 12),
        StockBatchesCard(batches: batches, fmt: fmt),
        const SizedBox(height: 30),
      ],
    );
  }
}
