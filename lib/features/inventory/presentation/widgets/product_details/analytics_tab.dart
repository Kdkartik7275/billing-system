import 'package:billing_system/core/extensions/stock_transactions_type_x.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/breakdown_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/info_card.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/info_row.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/legend.dart';

import 'package:flutter/material.dart';

class AnalyticsTab extends StatelessWidget {
  final List<StockTransaction> transactions;
  final InventoryProduct product;
  final String Function(double) fmt;
  final int totalIn;
  final int totalOut;
  final int totalDamaged;

  const AnalyticsTab({
    super.key,
    required this.transactions,
    required this.product,
    required this.fmt,
    required this.totalIn,
    required this.totalOut,
    required this.totalDamaged,
  });

  @override
  Widget build(BuildContext context) {
    final turnover = totalIn == 0 ? 0.0 : totalOut / totalIn * 100;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        InfoCard(
          title: 'Stock Analytics',
          icon: Icons.bar_chart_rounded,
          rows: [
            InfoRow('Total Purchased', '+$totalIn ${product.stockUnit}'),
            InfoRow('Total Sold', '-$totalOut ${product.stockUnit}'),
            InfoRow('Total Damaged', '-$totalDamaged ${product.stockUnit}'),
            InfoRow('Turnover Rate', '${turnover.toStringAsFixed(1)}%'),
            InfoRow('Current Stock', '${product.stock} ${product.stockUnit}'),
            InfoRow('Stock Value', fmt(product.totalValue)),
          ],
        ),
        const SizedBox(height: 14),
        InfoCard(
          title: 'Movement Breakdown',
          icon: Icons.donut_small_rounded,
          rows: const [],
          customChild: Column(
            children: [
              const SizedBox(height: 6),
              BreakdownBar(
                incoming: totalIn.toDouble(),
                outgoing: totalOut.toDouble(),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  LegendDot(
                    color: Color(0xFF16A34A),
                    label: 'Purchased / Returned',
                  ),
                  LegendDot(color: Color(0xFFEA580C), label: 'Sold'),
                  LegendDot(color: Color(0xFFDC2626), label: 'Damaged'),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InfoCard(
          title: 'Recent Activity (last 5)',
          icon: Icons.history_rounded,
          rows: transactions
              .take(5)
              .map(
                (t) => InfoRow(
                  t.type.label,
                  '${t.quantityChanged > 0 ? '+' : ''}${t.quantityChanged} ${product.stockUnit}',
                  valueColor: t.type.color,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
