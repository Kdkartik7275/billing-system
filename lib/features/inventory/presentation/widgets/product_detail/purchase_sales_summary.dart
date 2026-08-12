import 'package:billing_system/core/card/detail_section_card.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PurchaseSalesSummaryRow extends GetView<ProductDetailController> {
  final double sellingPrice;
  final VoidCallback? onViewPurchases;
  final VoidCallback? onViewSales;

  const PurchaseSalesSummaryRow({
    super.key,

    required this.sellingPrice,
    this.onViewPurchases,
    this.onViewSales,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sales = controller.stockMovements
          .where((m) => m.type == StockMovementType.saleOut)
          .toList();

      final totalPurchaseQty = controller.stockBatches.fold<double>(
        0,
        (sum, b) => sum + b.quantity,
      );
      final totalPurchaseValue = controller.stockBatches.fold<double>(
        0,
        (sum, b) => sum + (b.quantity * b.purchasePrice),
      );

      final totalSaleQty = sales.fold<double>(
        0,
        (sum, m) => sum + m.quantityChange.abs(),
      );
      final totalSaleValue = totalSaleQty * sellingPrice;
      return Column(
        children: [
          _SummaryCard(
            icon: Icons.shopping_cart_outlined,
            title: 'Purchase Summary',
            countLabel: 'Total Purchases',
            totalCount: controller.stockBatches.length,
            totalQty: totalPurchaseQty,
            totalValue: totalPurchaseValue,
            onViewAll: onViewPurchases,
            rows: controller.stockBatches
                .map(
                  (b) => _SummaryRowData(
                    date: b.receivedAt,
                    reference: b.batchNumber,
                    qty: b.quantity,
                    value: b.quantity * b.purchasePrice,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            icon: Icons.show_chart_rounded,
            title: 'Sales Summary',
            countLabel: 'Total Sales',
            totalCount: sales.length,
            totalQty: totalSaleQty,
            totalValue: totalSaleValue,
            onViewAll: onViewSales,
            rows: sales
                .map(
                  (m) => _SummaryRowData(
                    date: m.createdAt,
                    reference: m.referenceId ?? m.id,
                    qty: m.quantityChange.abs(),
                    value: m.quantityChange.abs() * sellingPrice,
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}

class _SummaryRowData {
  final DateTime date;
  final String reference;
  final double qty;
  final double value;

  const _SummaryRowData({
    required this.date,
    required this.reference,
    required this.qty,
    required this.value,
  });
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String countLabel;
  final int totalCount;
  final double totalQty;
  final double totalValue;
  final List<_SummaryRowData> rows;
  final VoidCallback? onViewAll;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.countLabel,
    required this.totalCount,
    required this.totalQty,
    required this.totalValue,
    required this.rows,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final visibleRows = rows.take(3).toList();

    return DetailSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: icon, title: title, onViewAll: onViewAll),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: countLabel,
                  value: totalCount.toString(),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Total Qty',
                  value: totalQty.toStringAsFixed(0),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Total Value',
                  value: '₹${totalValue.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          if (visibleRows.isNotEmpty) ...[
            const SizedBox(height: 10),
            Divider(height: 1, color: Colors.grey.shade200),
            ...visibleRows.map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        dateFmt.format(row.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        row.reference,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 10,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.qty.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '₹${row.value.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}
