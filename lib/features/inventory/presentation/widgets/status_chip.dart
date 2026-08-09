import 'package:flutter/material.dart';

import '../../domain/entities/stock_entity.dart';

class _StatusVisual {
  final Color color;
  final String label;
  final IconData icon;

  const _StatusVisual(this.color, this.label, this.icon);
}

_StatusVisual _visualFor(StockStatus status) {
  switch (status) {
    case StockStatus.outOfStock:
      return const _StatusVisual(
        Color(0xFFE5484D),
        'Out of stock',
        Icons.cancel_rounded,
      );
    case StockStatus.lowStock:
      return const _StatusVisual(
        Color(0xFFF5A524),
        'Low stock',
        Icons.error_rounded,
      );
    case StockStatus.inStock:
      return const _StatusVisual(
        Color(0xFF12B76A),
        'In stock',
        Icons.check_circle_rounded,
      );
  }
}

/// Status pill (icon + label). Sized to always fit the space it's given —
/// the label truncates with an ellipsis rather than overflowing, and the
/// whole chip never demands more width than its parent provides.
class StatusChip extends StatelessWidget {
  final StockStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(status);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: visual.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(visual.icon, size: 12, color: visual.color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                visual.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: visual.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
