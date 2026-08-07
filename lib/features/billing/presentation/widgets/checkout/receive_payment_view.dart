import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/numpad_button.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
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
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
              ),
              Text(
                "Receive Payment",
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ---------------- SCROLLABLE CONTENT ----------------
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- GRAND TOTAL (compact) ----------------
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

                const SizedBox(height: 14),

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

                // ---------------- QUICK AMOUNTS ----------------
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

                // ---------------- CHANGE TO RETURN (compact) ----------------
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

                // ---------------- PAYMENT SUMMARY (compact) ----------------
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
          child: // ---------------- NUMPAD ----------------
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 48,
            ),
            itemCount: 12,
            itemBuilder: (_, index) {
              if (index < 9) {
                final digit = '${index + 1}';
                return NumpadButton(
                  label: digit,
                  onTap: () => checkoutController.appendDigit(digit),
                );
              }
              if (index == 9) {
                return NumpadButton(
                  label: '.',
                  onTap: () => checkoutController.appendDigit('.'),
                );
              }
              if (index == 10) {
                return NumpadButton(
                  label: '0',
                  onTap: () => checkoutController.appendDigit('0'),
                );
              }
              return NumpadButton(
                icon: Icons.backspace_outlined,
                onTap: checkoutController.backspace,
              );
            },
          ),
        ),

        // ---------------- PINNED FOOTER ----------------
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Payment Successful",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Bill #${checkoutController.completedBill.value?.billNumber ?? ''}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final bill = checkoutController.completedBill.value;
                      if (bill != null) {
                        final shop = Get.find<UserController>().shop.value;
                        if (shop != null) {
                          printBill(bill: bill, shop: shop);
                        }
                      }
                      onClose();
                    },
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                if (checkoutController.errorMessage.value.isNotEmpty)
                  Padding(
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
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
              ],
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
