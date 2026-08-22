import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleRow extends StatelessWidget {
  final BillEntity bill;

  const SaleRow({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timeFmt = DateFormat('hh:mm a');

    final itemCount = bill.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity.toInt(),
    );

    final method = bill.payment.payments.isNotEmpty
        ? bill.payment.payments.first.method
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // PAYMENT ICON
          // ----------------------------------------------------------
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: _methodColor(method).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _methodIcon(method),
              size: 20,
              color: _methodColor(method),
            ),
          ),

          const SizedBox(width: 10),

          // ----------------------------------------------------------
          // SALE INFORMATION
          // ----------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bill number
                Text(
                  '#${bill.billNumber}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),

                const SizedBox(height: 4),

                // Time + Items
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        timeFmt.format(bill.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Flexible(
                      child: Text(
                        '• $itemCount item${itemCount == 1 ? '' : 's'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Customer
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        bill.customer?.name ?? 'Walk-in Customer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ----------------------------------------------------------
          // AMOUNT + PAYMENT METHOD
          // ----------------------------------------------------------
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount
              Text(
                '₹${bill.grandTotal.toStringAsFixed(2)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              // Payment method
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _methodLabel(method),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(width: 3),

                  Icon(
                    _methodIcon(method),
                    size: 13,
                    color: _methodColor(method),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // PAYMENT METHOD LABEL
  // --------------------------------------------------------------------------

  String _methodLabel(PaymentMethod? method) {
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
      case null:
        return 'Other';
    }
  }

  // --------------------------------------------------------------------------
  // PAYMENT METHOD ICON
  // --------------------------------------------------------------------------

  IconData _methodIcon(PaymentMethod? method) {
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
      case null:
        return Icons.more_horiz_rounded;
    }
  }

  // --------------------------------------------------------------------------
  // PAYMENT METHOD COLOR
  // --------------------------------------------------------------------------

  Color _methodColor(PaymentMethod? method) {
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
      case null:
        return Colors.grey.shade700;
    }
  }
}
