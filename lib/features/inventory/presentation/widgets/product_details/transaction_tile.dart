import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/extensions/stock_transactions_type_x.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/type_badge.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final StockTransaction transaction;
  final String stockUnit;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.stockUnit,
  });

  String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final type = t.type;
    final qtyStr =
        '${t.quantityChanged > 0 ? '+' : ''}${t.quantityChanged} $stockUnit';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          TypeBadge(type: type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.notes ?? t.referenceId ?? type.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${type.label}  ·  ${_fmtDate(t.createdAt)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                qtyStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: type.color,
                ),
              ),
              Text(
                '→ ${t.newStock} $stockUnit',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
