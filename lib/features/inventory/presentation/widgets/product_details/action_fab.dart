import 'package:billing_system/core/extensions/stock_transactions_type_x.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:flutter/material.dart';

class ActionFab extends StatelessWidget {
  final StockTransactionType type;
  final VoidCallback onTap;

  const ActionFab({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: type.label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: type.color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, color: Colors.white, size: 18),
              const SizedBox(height: 2),
              Text(
                type.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
