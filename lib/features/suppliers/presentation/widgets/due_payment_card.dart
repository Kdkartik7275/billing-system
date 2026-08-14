import 'package:flutter/material.dart';

class DuePayment {
  final String initials;
  final Color avatarColor;
  final Color avatarBgColor;
  final String supplierName;
  final String amount;
  final String statusText;
  final Color statusColor;

  const DuePayment({
    required this.initials,
    required this.avatarColor,
    required this.avatarBgColor,
    required this.supplierName,
    required this.amount,
    required this.statusText,
    required this.statusColor,
  });
}

class DuePaymentsCard extends StatelessWidget {
  final List<DuePayment> payments;
  final VoidCallback? onViewAll;
  final ValueChanged<DuePayment>? onTapPayment;

  const DuePaymentsCard({
    super.key,
    required this.payments,
    this.onViewAll,
    this.onTapPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Payments',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              InkWell(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B8A4C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < payments.length; i++) ...[
            _DuePaymentTile(
              payment: payments[i],
              onTap: onTapPayment == null
                  ? null
                  : () => onTapPayment!(payments[i]),
            ),
            if (i != payments.length - 1)
              const Divider(height: 1, color: Color(0xFFF0F1F3)),
          ],
        ],
      ),
    );
  }
}

class _DuePaymentTile extends StatelessWidget {
  final DuePayment payment;
  final VoidCallback? onTap;

  const _DuePaymentTile({required this.payment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: payment.avatarBgColor,
              child: Text(
                payment.initials,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due Amount',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 12.5,
                      color: Color(0xFF8B909A),
                    ),
                  ),
                  Text(
                    payment.amount,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE23744),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  payment.statusText,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: payment.statusColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB6BAC0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
