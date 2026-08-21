import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CashAmountSection extends StatelessWidget {
  final CheckoutController checkoutController;

  const CashAmountSection({super.key, required this.checkoutController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xff2962FF), width: 1.4),
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
                onTap: () => checkoutController.selectQuickAmount(amount),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff2962FF) : Colors.white,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
