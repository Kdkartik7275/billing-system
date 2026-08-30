import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showDuePaymentDetailDialog(
  BuildContext context, {
  required DuePayment payment,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => _DuePaymentDetailDialog(payment: payment),
  );
}

class _DuePaymentDetailDialog extends StatelessWidget {
  final DuePayment payment;

  const _DuePaymentDetailDialog({required this.payment});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final theme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- SUPPLIER HEADER ----------------
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: payment.avatarBgColor,
                  child: Text(
                    payment.initials,
                    style: theme.titleMedium!.copyWith(
                      color: payment.avatarColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.supplierName,
                        style: theme.titleMedium!.copyWith(),
                      ),
                      Text(
                        payment.statusText,
                        style: theme.titleSmall!.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: payment.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: Colors.black,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- AMOUNT DUE ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    'Amount Due',
                    style: theme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.amount,
                    style: theme.titleLarge!.copyWith(
                      fontSize: 20,
                      color: Color(0xFFE23744),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- DETAILS ----------------
            _DetailRow(
              icon: Icons.event_outlined,
              label: 'Due Date',
              value: dateFmt.format(payment.dueDate),
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.info_outline_rounded,
              label: 'Status',
              value: payment.statusText,
              valueColor: payment.statusColor,
            ),

            const SizedBox(height: 18),

            // ---------------- NOTES ----------------
            Text(
              'Notes (optional)',
              style: theme.titleSmall!.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Paid via bank transfer, ref #1234',
                hintStyle: theme.titleSmall!.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF1B8A4C),
                    width: 1.4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ---------------- ACTIONS ----------------
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1B8A4C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Mark as Paid',
                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 13.5,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
