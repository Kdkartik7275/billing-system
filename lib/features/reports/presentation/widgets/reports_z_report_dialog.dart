import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportsZReportDialog extends StatelessWidget {
  final ReportsController controller;

  const ReportsZReportDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 850),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF7F8FA),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 40,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              _DialogHeader(controller: controller),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    children: [
                      _ReceiptPreview(controller: controller),

                      const SizedBox(height: 18),

                      _DialogActions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HEADER
// -----------------------------------------------------------------------------

class _DialogHeader extends StatelessWidget {
  final ReportsController controller;

  const _DialogHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'dd MMM yyyy',
    ).format(controller.selectedDate.value);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
      decoration: const BoxDecoration(
        color: ReportColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Z-Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Daily closing report • $date',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xff67E8A5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'PREVIEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          IconButton(
            onPressed: Get.back,
            splashRadius: 22,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// RECEIPT
// -----------------------------------------------------------------------------

class _ReceiptPreview extends StatelessWidget {
  final ReportsController controller;

  const _ReceiptPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasVariance = controller.hasCountedCash;

    final variance = hasVariance
        ? controller.countedCash.value! - controller.expectedCash
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          // Receipt top
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
            child: Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F3F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 24,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'SMARTPOS',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F3F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Z-REPORT',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Kartik Super Mart',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Main Branch',
                  style: TextStyle(color: ReportColors.muted, fontSize: 9),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _ReceiptMeta(
                        label: 'REPORT DATE',
                        value: DateFormat(
                          'dd MMM yyyy',
                        ).format(controller.selectedDate.value),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: const Color(0xffE5E7EB),
                    ),
                    Expanded(
                      child: _ReceiptMeta(
                        label: 'REPORT TYPE',
                        value: 'DAILY CLOSE',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const _DashedDivider(),

          // Cash
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Column(
              children: [
                const _ReceiptSectionTitle(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Cash Reconciliation',
                ),

                const SizedBox(height: 10),

                _ReceiptRow(
                  'Opening Cash Float',
                  formatReportCurrency(controller.openingCashFloat.value),
                ),

                _ReceiptRow(
                  'Cash Sales',
                  formatReportCurrency(controller.cashSales),
                ),

                _ReceiptRow(
                  'Cash Refunds',
                  formatReportCurrency(controller.refundsAmount),
                  valueColor: const Color(0xffDC2626),
                ),

                _ReceiptRow(
                  'Payouts',
                  formatReportCurrency(controller.payouts.value),
                  valueColor: const Color(0xffDC2626),
                ),

                const SizedBox(height: 8),

                _ReceiptHighlightRow(
                  label: 'Expected Cash',
                  value: formatReportCurrency(controller.expectedCash),
                ),

                const SizedBox(height: 7),

                _ReceiptRow(
                  'Counted Cash',
                  controller.hasCountedCash
                      ? formatReportCurrency(controller.countedCash.value!)
                      : 'Not counted',
                  valueColor: controller.hasCountedCash
                      ? ReportColors.text
                      : ReportColors.muted,
                ),

                if (hasVariance) ...[
                  const SizedBox(height: 6),
                  _ReceiptVariance(variance: variance),
                ],
              ],
            ),
          ),

          const _ReceiptDivider(),

          // Sales
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                const _ReceiptSectionTitle(
                  icon: Icons.bar_chart_rounded,
                  title: 'Sales Summary',
                ),

                const SizedBox(height: 10),

                _ReceiptRow(
                  'Total Sales',
                  formatReportCurrency(controller.totalSales),
                ),

                _ReceiptRow('Total Bills', '${controller.totalBillsCount}'),

                _ReceiptRow('Voids', '${controller.voidsCount}'),

                _ReceiptRow(
                  'Discounts Given',
                  formatReportCurrency(controller.discountsGivenAmount),
                ),

                _ReceiptRow(
                  'Refunds',
                  formatReportCurrency(controller.refundsAmount),
                  valueColor: const Color(0xffDC2626),
                ),
              ],
            ),
          ),

          const _ReceiptDivider(),

          // Tender
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child: Column(
              children: [
                const _ReceiptSectionTitle(
                  icon: Icons.payments_outlined,
                  title: 'Tender Breakdown',
                ),

                const SizedBox(height: 10),

                for (final tender in controller.tenderBreakdown)
                  _ReceiptRow(
                    tender.label,
                    formatReportCurrency(tender.amount),
                  ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF7F8FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 15,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'End of daily report',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Thank you for your business!',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Powered by SmartPOS',
                  style: TextStyle(color: ReportColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// RECEIPT COMPONENTS
// -----------------------------------------------------------------------------

class _ReceiptMeta extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: ReportColors.muted,
            fontSize: 7,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _ReceiptSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ReceiptSectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black87),
        const SizedBox(width: 7),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.65,
          ),
        ),
        const SizedBox(width: 9),
        const Expanded(child: Divider(color: Color(0xffE5E7EB), height: 1)),
      ],
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ReceiptRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xff555B64),
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xff20242A),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptHighlightRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptHighlightRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xffF4F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _ReceiptVariance extends StatelessWidget {
  final double variance;

  const _ReceiptVariance({required this.variance});

  @override
  Widget build(BuildContext context) {
    final isExact = variance == 0;
    final isShort = variance < 0;

    final color = isExact
        ? const Color(0xff16803C)
        : isShort
        ? const Color(0xffDC2626)
        : const Color(0xff2563EB);

    final icon = isExact
        ? Icons.check_circle_outline_rounded
        : isShort
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    final label = isExact
        ? 'Cash balanced'
        : isShort
        ? 'Cash short'
        : 'Cash over';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            formatReportCurrency(variance.abs()),
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Divider(color: Color(0xffE5E7EB), height: 1),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 5.0;
          const gap = 4.0;

          final count = (constraints.maxWidth / (dashWidth + gap)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              count,
              (_) => Container(
                width: dashWidth,
                height: 1,
                color: const Color(0xffD9DDE2),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ACTIONS
// -----------------------------------------------------------------------------

class _DialogActions extends StatelessWidget {
  const _DialogActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.print_outlined,
            label: 'Print',
            onPressed: () {},
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _ActionButton(
            icon: Icons.download_outlined,
            label: 'Download',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        label: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: ReportColors.text,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xffE1E4E8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
