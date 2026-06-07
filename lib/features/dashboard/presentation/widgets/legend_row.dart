import 'package:billing_system/features/dashboard/presentation/models/dashboard_card_model.dart';
import 'package:flutter/material.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({
    super.key,
    required this.data,
    required this.isActive,
    required this.onTap,
  });
  final CategoryData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2.5),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isActive
              ? data.color.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 5, backgroundColor: data.color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: const Color(0xFF4A4A6A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${data.percentage}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: data.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
