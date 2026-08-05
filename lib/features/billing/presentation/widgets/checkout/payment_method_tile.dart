import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodType type;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff2962FF) : Colors.grey.shade200,
            width: isSelected ? 1.4 : 1,
          ),
          color: isSelected
              ? const Color(0xff2962FF).withValues(alpha: .04)
              : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(type.icon, color: type.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: theme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    type.subtitle,
                    style: theme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xff2962FF)
                  : Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
