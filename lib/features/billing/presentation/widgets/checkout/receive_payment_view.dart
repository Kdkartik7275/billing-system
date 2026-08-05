import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/numpad_button.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivePaymentView extends StatelessWidget {
  final CheckoutController checkoutController;
  final VoidCallback onClose;

  const ReceivePaymentView({
    super.key,
    required this.checkoutController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        // ---------------- HEADER ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: checkoutController.backToPaymentMethod,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Text(
                "Receive Payment",
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
                // ---------------- GRAND TOTAL ----------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF8ED),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Grand Total",
                        style: theme.bodySmall?.copyWith(
                          color: const Color(0xff2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                          style: theme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- PAYMENT METHOD ----------------
                Text(
                  "Payment Method",
                  style: theme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => PaymentMethodTile(
                    type: checkoutController.selectedMethod.value,
                    isSelected: true,
                    onTap: checkoutController.backToPaymentMethod,
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- AMOUNT RECEIVED ----------------
                Text(
                  "Amount Received",
                  style: theme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xff2962FF),
                        width: 1.4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "₹",
                          style: theme.headlineSmall?.copyWith(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            checkoutController.amountReceived.value.isEmpty
                                ? "0"
                                : checkoutController.amountReceived.value,
                            style: theme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (checkoutController.amountReceived.value.isNotEmpty)
                          InkWell(
                            onTap: checkoutController.clearAmount,
                            borderRadius: BorderRadius.circular(20),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey.shade200,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ---------------- QUICK AMOUNTS ----------------
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: checkoutController.quickAmounts.map((amount) {
                      final isSelected =
                          checkoutController.amountReceivedValue == amount &&
                          checkoutController.amountReceived.value.isNotEmpty;

                      return InkWell(
                        onTap: () =>
                            checkoutController.selectQuickAmount(amount),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff2962FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xff2962FF)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            "₹${amount.toStringAsFixed(0)}",
                            style: theme.bodyMedium?.copyWith(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------------- CHANGE TO RETURN ----------------
                Obx(() {
                  if (checkoutController.amountReceived.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF8ED),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change to Return",
                                style: theme.bodySmall?.copyWith(
                                  color: const Color(0xff2E7D32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${checkoutController.changeToReturn.toStringAsFixed(2)}",
                                style: theme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xff2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.currency_exchange_rounded,
                          color: Color(0xff2E7D32),
                          size: 34,
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // ---------------- PAYMENT SUMMARY ----------------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Summary",
                        style: theme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _SummaryRow(
                          label: "Grand Total",
                          value:
                              "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => _SummaryRow(
                          label: "Amount Received",
                          value:
                              "₹${checkoutController.amountReceivedValue.toStringAsFixed(2)}",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      Obx(
                        () => _SummaryRow(
                          label: "Change to Return",
                          value:
                              "₹${checkoutController.changeToReturn.toStringAsFixed(2)}",
                          valueColor: const Color(0xff2E7D32),
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- NUMPAD ----------------
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: [
                    for (final digit in [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                    ])
                      NumpadButton(
                        label: digit,
                        onTap: () => checkoutController.appendDigit(digit),
                      ),
                    NumpadButton(
                      label: '.',
                      onTap: () => checkoutController.appendDigit('.'),
                    ),
                    NumpadButton(
                      label: '0',
                      onTap: () => checkoutController.appendDigit('0'),
                    ),
                    NumpadButton(
                      icon: Icons.backspace_outlined,
                      onTap: checkoutController.backspace,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const Divider(height: 1),

        // ---------------- FOOTER ----------------
        Obx(() {
          if (checkoutController.paymentSuccessful.value) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xff2E7D32),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.check,
                      color: Color(0xff2E7D32),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Successful",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Successful",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.print_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      "Print Receipt",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    checkoutController.amountReceivedValue >=
                        checkoutController.grandTotal
                    ? checkoutController.confirmPayment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2962FF),
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

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
          value,
          style: theme.bodyMedium?.copyWith(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
