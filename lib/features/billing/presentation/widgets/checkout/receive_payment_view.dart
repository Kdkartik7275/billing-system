import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/numpad_button.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivePaymentView extends StatelessWidget {
  final CheckoutController checkoutController;

  const ReceivePaymentView({super.key, required this.checkoutController});

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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF8ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Grand Total",
                        style: theme.bodySmall?.copyWith(
                          color: const Color(0xff2E7D32),
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => Text(
                          "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                          style: theme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

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

                const SizedBox(height: 14),

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
                      vertical: 12,
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
                          style: theme.titleLarge?.copyWith(
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
                            style: theme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (checkoutController.amountReceived.value.isNotEmpty)
                          InkWell(
                            onTap: checkoutController.clearAmount,
                            borderRadius: BorderRadius.circular(20),
                            child: CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.grey.shade200,
                              child: Icon(
                                Icons.close,
                                size: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                            horizontal: 14,
                            vertical: 8,
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
                            style: theme.bodySmall?.copyWith(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                Obx(() {
                  if (checkoutController.amountReceived.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF8ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.currency_exchange_rounded,
                          color: Color(0xff2E7D32),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Change to Return",
                          style: theme.bodySmall?.copyWith(
                            color: const Color(0xff2E7D32),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₹${checkoutController.changeToReturn.toStringAsFixed(2)}",
                          style: theme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff2E7D32),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => _SummaryRow(
                          label: "Amount Received",
                          value:
                              "₹${checkoutController.amountReceivedValue.toStringAsFixed(2)}",
                        ),
                      ),
                      const SizedBox(height: 6),
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
              ],
            ),
          ),
        ),

        const Divider(height: 1),

        // ---------------- PINNED NUMPAD ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.1,
            children: [
              for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
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
        ),

        // ---------------- PINNED FOOTER ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Obx(() {
                if (checkoutController.errorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xffD32F2F),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          checkoutController.errorMessage.value,
                          style: theme.bodySmall?.copyWith(
                            color: const Color(0xffD32F2F),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        (checkoutController.amountReceivedValue >=
                                checkoutController.grandTotal &&
                            !checkoutController.isProcessing.value)
                        ? checkoutController.confirmPayment
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2962FF),
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: checkoutController.isProcessing.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            "Confirm Payment",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
          style: theme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.bodySmall?.copyWith(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
