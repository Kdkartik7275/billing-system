import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';

class QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const QuickStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
