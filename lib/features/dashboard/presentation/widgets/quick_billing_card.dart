import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class QuickBillingCard extends StatelessWidget {
  final VoidCallback onScan;

  const QuickBillingCard({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Billing',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15151A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scan barcode or QR to\ncreate a new bill',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.25,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Scan button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onScan,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.center_focus_strong_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Scan Now',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade600,
            size: 22,
          ),
        ],
      ),
    );
  }
}
