import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> showDuePaymentDetailDialog(
  BuildContext context, {
  required DuePayment payment,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _DuePaymentDetailDialog(payment: payment),
  );
}

class _DuePaymentDetailDialog extends StatefulWidget {
  final DuePayment payment;

  const _DuePaymentDetailDialog({required this.payment});

  @override
  State<_DuePaymentDetailDialog> createState() =>
      _DuePaymentDetailDialogState();
}

class _DuePaymentDetailDialogState extends State<_DuePaymentDetailDialog> {
  final SuppliersController controller = Get.find<SuppliersController>();

  final TextEditingController _amountPaidController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  static const List<String> _paymentMethods = [
    'Cash',
    'UPI',
    'Card',
    'Bank Transfer',
    'Cheque',
    'Other',
  ];

  String _selectedPaymentMethod = _paymentMethods.first;

  DuePayment get payment => widget.payment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPaymentsForSupplier(payment.supplierId);
    });
  }

  @override
  void dispose() {
    _amountPaidController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountPaidController.text);

    if (amount == null || amount <= 0) {
      AppSnackbar.error(message: 'Please enter a valid amount to pay.');
      return;
    }

    await controller.makePaymentForSupplier(
      supplierId: payment.supplierId,
      amount: amount,
      paymentMethod: _selectedPaymentMethod,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final theme = Theme.of(context).textTheme;
    final hintStyle = theme.bodyMedium!.copyWith(color: Colors.grey.shade400);
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.92 : 440.0;

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    );
    final focusedFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1B8A4C), width: 1.4),
    );

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: payment.avatarBgColor,
                    child: Text(
                      payment.initials,
                      style: theme.titleSmall!.copyWith(
                        color: payment.avatarColor,
                        fontWeight: FontWeight.w700,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payment.statusText,
                          style: theme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: payment.statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD9D6)),
                ),
                child: Column(
                  children: [
                    Text(
                      'AMOUNT DUE',
                      style: theme.labelSmall!.copyWith(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      payment.amount,
                      style: theme.headlineSmall!.copyWith(
                        color: const Color(0xFFE23744),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Payment History',
                style: theme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                if (controller.isLoadingPayments.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final payments = controller.supplierPayments;

                if (payments.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(
                        'No payments recorded yet',
                        style: theme.bodySmall!.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  );
                }

                final total = payments.fold<double>(
                  0,
                  (sum, p) => sum + p.amount,
                );
                final dateFmt = DateFormat('dd MMM yyyy');

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 190),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                          itemCount: payments.length,
                          itemBuilder: (_, index) {
                            final p = payments[index];
                            final hasNote =
                                p.notes != null && p.notes!.trim().isNotEmpty;
                            final hasRef =
                                p.referenceNumber != null &&
                                p.referenceNumber!.trim().isNotEmpty;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: p.paymentMethod,
                                                style: theme.bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black87,
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '  •  ${dateFmt.format(p.paymentDate)}',
                                                style: theme.bodySmall!
                                                    .copyWith(
                                                      fontSize: 11.5,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (hasRef || hasNote) ...[
                                          const SizedBox(height: 1),
                                          Text(
                                            hasRef && hasNote
                                                ? 'Ref #${p.referenceNumber} · ${p.notes}'
                                                : hasRef
                                                ? 'Ref #${p.referenceNumber}'
                                                : p.notes!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.bodySmall!.copyWith(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${p.amount.toStringAsFixed(2)}',
                                    style: theme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // ---- dashed divider, receipt-style ----
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: CustomPaint(
                          painter: _DashedLinePainter(
                            color: Colors.grey.shade300,
                          ),
                          child: const SizedBox(
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Paid',
                              style: theme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              '₹${total.toStringAsFixed(2)}',
                              style: theme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1B8A4C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              Text(
                'Amount to Pay',
                style: theme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountPaidController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Enter amount to pay',
                  hintStyle: hintStyle,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 4),
                    child: Text(
                      '₹',
                      style: theme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  enabledBorder: fieldBorder,
                  focusedBorder: focusedFieldBorder,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Payment Method',
                style: theme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                initialValue: _selectedPaymentMethod,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600,
                ),
                style: theme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  enabledBorder: fieldBorder,
                  focusedBorder: focusedFieldBorder,
                ),
                items: _paymentMethods
                    .map(
                      (method) =>
                          DropdownMenuItem(value: method, child: Text(method)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedPaymentMethod = value);
                },
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.event_outlined,
                      label: 'Due Date',
                      value: dateFmt.format(payment.dueDate),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _DetailRow(
                      icon: Icons.info_outline_rounded,
                      label: 'Status',
                      value: payment.statusText,
                      valueColor: payment.statusColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Notes (optional)',
                style: theme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                style: theme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'e.g. Paid via bank transfer, ref #1234',
                  hintStyle: hintStyle,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  enabledBorder: fieldBorder,
                  focusedBorder: focusedFieldBorder,
                ),
              ),

              const SizedBox(height: 22),

              Obx(() {
                final isSubmitting = controller.isMakingPayment.value;

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
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
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: isSubmitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1B8A4C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Record Payment',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade500),
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
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashGap;

  _DashedLinePainter({
    required this.color,
    this.dashWidth = 4,
    this.dashGap = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
