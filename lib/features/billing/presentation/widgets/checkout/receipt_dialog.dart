import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> showReceiptDialog(
  BuildContext context, {
  required BillEntity bill,
}) async {
  final screenSize = MediaQuery.of(context).size;
  final dialogWidth = screenSize.width < 440 ? screenSize.width * .94 : 420.0;
  final dialogHeight = screenSize.height < 700
      ? screenSize.height * .85
      : 640.0;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 24),
        backgroundColor: Colors.transparent,
        child: Center(
          child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ReceiptDialogContent(bill: bill),
            ),
          ),
        ),
      );
    },
  );
}

class ReceiptDialogContent extends StatelessWidget {
  final BillEntity bill;

  const ReceiptDialogContent({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Column(
      children: [
        // ---------------- HEADER ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xffEAF8ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xff2E7D32),
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Payment Successful",
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                "Bill No: ${bill.billNumber}",
                style: theme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ---------------- SCROLLABLE RECEIPT BODY ----------------
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(bill.createdAt),
                  style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),

                for (final item in bill.items) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.productName,
                            style: theme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "₹${item.total.toStringAsFixed(2)}",
                          style: theme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${item.quantity % 1 == 0 ? item.quantity.toStringAsFixed(0) : item.quantity.toStringAsFixed(2)} x ₹${item.unitPrice.toStringAsFixed(2)}",
                    style: theme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),

                _ReceiptRow(label: "Subtotal", value: bill.subTotal),
                if (bill.discount > 0)
                  _ReceiptRow(
                    label: "Discount",
                    value: -bill.discount,
                    valueColor: const Color(0xff2E7D32),
                  ),
                _ReceiptRow(label: "Tax (GST)", value: bill.tax),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
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
                      "₹${bill.grandTotal.toStringAsFixed(2)}",
                      style: theme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      for (final payment in bill.payment.payments)
                        _ReceiptRow(
                          label: "Paid (${payment.method.name})",
                          value: payment.amount,
                        ),
                      if (bill.payment.changeAmount > 0)
                        _ReceiptRow(
                          label: "Change Returned",
                          value: bill.payment.changeAmount,
                          valueColor: const Color(0xff2E7D32),
                        ),
                    ],
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
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "Done",
                    style: theme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final shop = Get.find<UserController>().shop.value;
                    if (shop != null) {
                      printBill(bill: bill, shop: shop);
                    }
                  },
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: const Text("Print Receipt"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2962FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

class _ReceiptRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
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
      ),
    );
  }
}
