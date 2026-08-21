import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CardOrOtherSection extends StatelessWidget {
  final CheckoutController checkoutController;

  const CardOrOtherSection({super.key, required this.checkoutController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      final method = checkoutController.selectedMethod.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(method.icon, size: 36, color: method.color),
            const SizedBox(height: 12),
            Text(
              "Process ₹${checkoutController.grandTotal.toStringAsFixed(2)} on the ${method.label} terminal",
              textAlign: TextAlign.center,
              style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "Confirm once the payment is completed",
              textAlign: TextAlign.center,
              style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    });
  }
}
