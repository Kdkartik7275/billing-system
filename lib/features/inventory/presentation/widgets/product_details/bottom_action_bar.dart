import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/action_fab.dart';
import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final void Function(StockTransactionType) onTap;

  const BottomActionBar({super.key, required this.onTap});

  static const _actions = [
    StockTransactionType.purchase,
    StockTransactionType.sale,
    StockTransactionType.returnStock,
    StockTransactionType.damage,
    StockTransactionType.adjustment,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _actions.asMap().entries.map((e) {
          final isLast = e.key == _actions.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              child: ActionFab(type: e.value, onTap: () => onTap(e.value)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
