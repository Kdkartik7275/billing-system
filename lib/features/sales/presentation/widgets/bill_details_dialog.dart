import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_summary_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillDetailsDialog extends StatelessWidget {
  final BillEntity bill;

  final VoidCallback? onPrintReceipt;

  const BillDetailsDialog({super.key, required this.bill, this.onPrintReceipt});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy, hh:mm a');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(bill: bill, dateFmt: dateFmt),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CustomerSection(bill: bill),
                    const SizedBox(height: 18),
                    _ItemsSection(items: bill.items),
                    const SizedBox(height: 18),
                    _TotalsSection(bill: bill),
                    const SizedBox(height: 18),
                    _PaymentSection(payment: bill.payment),
                  ],
                ),
              ),
            ),
            _Footer(onPrintReceipt: onPrintReceipt),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final BillEntity bill;
  final DateFormat dateFmt;

  const _Header({required this.bill, required this.dateFmt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '#${bill.billNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(status: bill.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dateFmt.format(bill.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: Colors.black54),
              splashRadius: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BillStatus status;

  const _StatusChip({required this.status});

  Color get _color {
    switch (status) {
      case BillStatus.completed:
        return const Color(0xff2E7D32);
      case BillStatus.pending:
        return const Color(0xffEF6C00);
      case BillStatus.cancelled:
        return Colors.grey.shade700;
      case BillStatus.refunded:
        return const Color(0xffC62828);
    }
  }

  String get _label {
    switch (status) {
      case BillStatus.completed:
        return 'Completed';
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.cancelled:
        return 'Cancelled';
      case BillStatus.refunded:
        return 'Refunded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _CustomerSection extends StatelessWidget {
  final BillEntity bill;

  const _CustomerSection({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customer = bill.customer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer?.name ?? 'Walk-in Customer',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (customer?.phone != null || customer?.email != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if (customer?.phone != null) customer!.phone!,
                        if (customer?.email != null) customer!.email!,
                      ].join(' • '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsSection extends StatelessWidget {
  final List<BillItemEntity> items;

  const _ItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ITEMS (${items.length})',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => _ItemRow(item: item)),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final BillItemEntity item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₹${item.total.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'SKU: ${item.sku}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${_fmtQty(item.quantity)} × ₹${item.unitPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              if (item.discount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  'Disc: -₹${item.discount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffC62828),
                  ),
                ),
              ],
              if (item.tax > 0) ...[
                const SizedBox(width: 8),
                Text(
                  'Tax (${item.taxPercent.toStringAsFixed(0)}%): ₹${item.tax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _fmtQty(double qty) {
    return qty == qty.roundToDouble()
        ? qty.toInt().toString()
        : qty.toStringAsFixed(2);
  }
}

class _TotalsSection extends StatelessWidget {
  final BillEntity bill;

  const _TotalsSection({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _totalRow('Subtotal', bill.subTotal, theme),
          if (bill.discount > 0)
            _totalRow(
              'Discount',
              -bill.discount,
              theme,
              color: const Color(0xffC62828),
            ),
          if (bill.tax > 0) _totalRow('Tax', bill.tax, theme),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _totalRow('Grand Total', bill.grandTotal, theme, isBold: true),
        ],
      ),
    );
  }

  Widget _totalRow(
    String label,
    double amount,
    ThemeData theme, {
    bool isBold = false,
    Color? color,
  }) {
    final sign = amount < 0 ? '-' : '';
    final display = amount.abs().toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
          ),
          Text(
            '$sign₹$display',
            style: isBold
                ? theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: color ?? Colors.grey.shade800,
                  ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final PaymentSummaryEntity payment;

  const _PaymentSection({required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        ...payment.payments.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(
                  _methodIcon(p.method),
                  size: 16,
                  color: _methodColor(p.method),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _methodLabel(p.method),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '₹${p.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (payment.changeAmount > 0)
          _summaryRow(
            'Change Given',
            payment.changeAmount,
            theme,
            Colors.grey.shade700,
          ),
        if (payment.pendingAmount > 0)
          _summaryRow(
            'Pending',
            payment.pendingAmount,
            theme,
            const Color(0xffC62828),
          ),
      ],
    );
  }

  Widget _summaryRow(
    String label,
    double amount,
    ThemeData theme,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _methodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  IconData _methodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.upi:
        return Icons.qr_code_rounded;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethod.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color _methodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return const Color(0xff2E7D32);
      case PaymentMethod.card:
        return const Color(0xff1565C0);
      case PaymentMethod.upi:
        return const Color(0xffEF6C00);
      case PaymentMethod.wallet:
        return const Color(0xff6A1B9A);
      case PaymentMethod.other:
        return Colors.grey.shade700;
    }
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback? onPrintReceipt;

  const _Footer({this.onPrintReceipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: onPrintReceipt,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.print_rounded, size: 18,color: Colors.white),
                label: Text(
                  'Print Receipt',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
