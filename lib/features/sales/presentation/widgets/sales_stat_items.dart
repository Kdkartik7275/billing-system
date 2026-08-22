import 'package:flutter/material.dart';

class SalesStatItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const SalesStatItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
