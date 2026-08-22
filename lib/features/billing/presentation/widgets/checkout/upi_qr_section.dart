import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UpiQrSection extends StatelessWidget {
  final CheckoutController checkoutController;

  const UpiQrSection({super.key, required this.checkoutController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      final amount = checkoutController.grandTotal;

      final upiUri =
          'upi://pay?pa=your-shop-upi-id@bank&pn=YourShopName&am=${amount.toStringAsFixed(2)}&cu=INR';

      return Center(
        child: Column( 
          children: [
            Text(
              "Scan to Pay",
              style: theme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: upiUri,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "₹${amount.toStringAsFixed(2)}",
              style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              "Ask the customer to scan and pay the exact amount",
              textAlign: TextAlign.center,
              style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    });
  }
}
