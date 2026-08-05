import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/order_summary_tile.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProceedToPaymentView extends StatelessWidget {
  final CheckoutController checkoutController;
  final CartController cartController;
  final VoidCallback onEditCart;

  const ProceedToPaymentView({
    super.key,
    required this.checkoutController,
    required this.cartController,
    required this.onEditCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        // ---------------- HEADER ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                "Proceed to Payment",
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onEditCart,
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: const Text("Edit Cart"),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff2962FF),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- CUSTOMER ----------------
                Text(
                  "Customer",
                  style: theme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => Expanded(
                          child: Text(
                            checkoutController.customerName.value,
                            style: theme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- ORDER SUMMARY ----------------
                Text(
                  "Order Summary",
                  style: theme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final items = cartController.cartItems.values.toList();
                  return Column(
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        OrderSummaryTile(item: items[i]),
                        if (i != items.length - 1) const Divider(height: 1),
                      ],
                    ],
                  );
                }),

                const SizedBox(height: 16),

                // ---------------- BILL BREAKDOWN ----------------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(
                    () => Column(
                      children: [
                        _BillRow(
                          label: "Subtotal",
                          value: checkoutController.subtotal,
                        ),
                        const SizedBox(height: 8),
                        _BillRow(
                          label: "Discount",
                          value: -checkoutController.discount.value,
                          valueColor: const Color(0xff2E7D32),
                        ),
                        const SizedBox(height: 8),
                        _BillRow(
                          label: "Tax (GST)",
                          value: checkoutController.tax,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1),
                        ),
                        Row(
                          children: [
                            Text(
                              "Grand Total",
                              style: theme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                              style: theme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff2962FF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- PAYMENT METHOD ----------------
                Text(
                  "Select Payment Method",
                  style: theme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: PaymentMethodType.values
                        .map(
                          (type) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: PaymentMethodTile(
                              type: type,
                              isSelected:
                                  checkoutController.selectedMethod.value ==
                                  type,
                              onTap: () =>
                                  checkoutController.selectPaymentMethod(type),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const Divider(height: 1),

        // ---------------- FOOTER ----------------
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payable Amount",
                      style: theme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Obx(
                      () => Text(
                        "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: checkoutController.goToReceivePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2962FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Collect Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;

  const _BillRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          label,
          style: theme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          "${value < 0 ? '- ' : ''}₹${value.abs().toStringAsFixed(2)}",
          style: theme.bodyMedium?.copyWith(
            color: valueColor ?? Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
