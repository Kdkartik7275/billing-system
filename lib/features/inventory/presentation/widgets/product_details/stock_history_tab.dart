import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/summary_tile.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/transaction_tile.dart';
import 'package:flutter/material.dart';

class StockHistoryTab extends StatelessWidget {
  final List<StockTransaction> transactions;
  final int totalIn;
  final int totalOut;
  final InventoryProduct product;

  const StockHistoryTab({
    super.key,
    required this.transactions,
    required this.totalIn,
    required this.totalOut,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryTile(
                label: 'Stock In',
                value: '+$totalIn',
                icon: Icons.arrow_downward_rounded,
                bgColor: const Color(0xFFDCFCE7),
                color: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryTile(
                label: 'Stock Out',
                value: '-$totalOut',
                icon: Icons.arrow_upward_rounded,
                bgColor: const Color(0xFFFFF7ED),
                color: const Color(0xFFEA580C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Movement Log',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...transactions.map(
          (t) => TransactionTile(transaction: t, stockUnit: product.stockUnit),
        ),
      ],
    );
  }
}