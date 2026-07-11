import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color color;

  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
