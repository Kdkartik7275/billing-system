import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SalesScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SalesScanButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffE5E7EB),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              size: 22,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Scan Bill',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}