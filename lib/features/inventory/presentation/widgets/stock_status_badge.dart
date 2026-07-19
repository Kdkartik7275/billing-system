import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:flutter/material.dart';

class StockStatusBadge extends StatelessWidget {
  final StockStatus status;

  const StockStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      StockStatus.inStock => (
        'In Stock',
        const Color(0xFFECFDF5),
        const Color(0xFF059669),
      ),
      StockStatus.lowStock => (
        'Low Stock',
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
      ),
      StockStatus.outOfStock => (
        'Out of Stock',
        const Color(0xFFFEF2F2),
        const Color(0xFFDC2626),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: fg),
      ),
    );
  }
}
