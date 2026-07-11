import 'package:billing_system/core/extensions/stock_transactions_type_x.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:flutter/material.dart';

class TypeBadge extends StatelessWidget {
  final StockTransactionType type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: type.bgColor, shape: BoxShape.circle),
      child: Icon(type.icon, color: type.color, size: 18),
    );
  }
}
