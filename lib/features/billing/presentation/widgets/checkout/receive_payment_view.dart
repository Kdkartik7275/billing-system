import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/card_section.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/cash_amount_section.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/numpad_button.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/upi_qr_section.dart';
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
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
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
                // ---------------- GRAND TOTAL (SHARED) ----------------
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

                // ---------------- PAYMENT METHOD (SHARED) ----------------
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

                // ---------------- METHOD-SPECIFIC BODY ----------------
                Obx(() {
                  if (checkoutController.requiresQrDisplay) {
                    return UpiQrSection(checkoutController: checkoutController);
                  }

                  if (checkoutController.requiresAmountEntry) {
                    return CashAmountSection(
                      checkoutController: checkoutController,
                    );
                  }

                  return CardOrOtherSection(
                    checkoutController: checkoutController,
                  );
                }),
              ],
            ),
          ),
        ),

        const Divider(height: 1),

        // ---------------- PINNED NUMPAD (CASH ONLY) ----------------
        Obx(() {
          if (!checkoutController.requiresAmountEntry) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.1,
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
          );
        }),

        // ---------------- PINNED FOOTER (SHARED) ----------------
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
                        : Obx(
                            () => Text(
                              checkoutController.requiresQrDisplay
                                  ? "Confirm Payment Received"
                                  : "Confirm Payment",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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
