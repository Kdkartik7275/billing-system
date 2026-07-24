import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_radius.dart';
import '../../domain/entities/stock_entity.dart';

/// Small colored pill showing a product's [StockStatus].
class StatusChip extends StatelessWidget {
  final StockStatus status;

  const StatusChip({super.key, required this.status});

  ({Color color, String label}) get _config => switch (status) {
        StockStatus.inStock => (color: const Color(0xFF16A34A), label: 'In Stock'),
        StockStatus.lowStock => (color: const Color(0xFFEA580C), label: 'Low Stock'),
        StockStatus.outOfStock => (color: const Color(0xFFDC2626), label: 'Out of Stock'),
      };

  @override
  Widget build(BuildContext context) {
    final config = _config;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: config.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }
}
