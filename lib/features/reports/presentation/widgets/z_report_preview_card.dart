import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ZReportPreviewCard extends GetView<ReportsController> {
  const ZReportPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ReportColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Z-Report Preview',
                    style: TextStyle(
                      color: ReportColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Print Z-Report',
                  onPressed: () {
                    // TODO: Integrate printer service.
                  },
                  icon: const Icon(
                    Icons.print_outlined,
                    color: ReportColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ReportColors.border),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: _DesktopReceiptPreview(controller: controller),
            ),
          ),
          const Divider(height: 1, color: ReportColors.border),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // TODO: Integrate printer service.
                    },
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      backgroundColor: ReportColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Generate PDF using your PDF service.
                    },
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download PDF'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      foregroundColor: ReportColors.primary,
                      side: const BorderSide(color: ReportColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Integrate sharing service.
                    },
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      foregroundColor: ReportColors.primary,
                      side: const BorderSide(color: ReportColors.primary),
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

class _DesktopReceiptPreview extends StatelessWidget {
  final ReportsController controller;

  const _DesktopReceiptPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final varianceColor = !controller.hasCountedCash
        ? ReportColors.secondaryText
        : controller.variance == 0
        ? ReportColors.green
        : ReportColors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xff2B2B2B),
          fontSize: 10,
          height: 1.35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 34,
                    color: Colors.black,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'SmartPOS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Z-REPORT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .3,
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    'Kartik Super Mart',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Main Branch',
                    style: TextStyle(
                      fontSize: 9,
                      color: ReportColors.secondaryText,
                    ),
                  ),
                  Text(
                    'Roorkee, Uttarakhand',
                    style: TextStyle(
                      fontSize: 9,
                      color: ReportColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat('dd MMM yyyy').format(controller.selectedDate.value)}',
                  ),
                ),
                Text('Time: ${DateFormat('hh:mm a').format(DateTime.now())}'),
              ],
            ),
            const SizedBox(height: 3),
            const Text('Day Close No: 001'),
            const SizedBox(height: 9),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 11),
            const _ReceiptHeading('CASH RECONCILIATION'),
            const SizedBox(height: 5),
            _ReceiptRow(
              label: 'Opening Cash Float',
              value: formatReportCurrency(controller.openingCashFloat.value),
            ),
            _ReceiptRow(
              label: 'Cash Sales',
              value: formatReportCurrency(controller.cashSales),
            ),
            _ReceiptRow(
              label: 'Cash Refunds',
              value: formatReportCurrency(controller.refundsAmount),
            ),
            _ReceiptRow(
              label: 'Payouts',
              value: formatReportCurrency(controller.payouts.value),
            ),
            const SizedBox(height: 5),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 5),
            _ReceiptRow(
              label: 'Expected Cash',
              value: formatReportCurrency(controller.expectedCash),
              bold: true,
            ),
            _ReceiptRow(
              label: 'Counted Cash',
              value: controller.hasCountedCash
                  ? formatReportCurrency(controller.countedCash.value!)
                  : 'Not Counted',
              bold: true,
            ),
            if (controller.hasCountedCash)
              _ReceiptRow(
                label: 'Variance',
                value:
                    '${formatReportCurrency(controller.variance)} (${controller.varianceLabel})',
                bold: true,
                valueColor: varianceColor,
                labelColor: varianceColor,
              ),
            const SizedBox(height: 11),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 11),
            const _ReceiptHeading('SALES SUMMARY'),
            const SizedBox(height: 5),
            _ReceiptRow(
              label: 'Total Sales',
              value: formatReportCurrency(controller.totalSales),
              bold: true,
            ),
            _ReceiptRow(
              label: 'Total Bills',
              value: '${controller.totalBillsCount}',
            ),
            _ReceiptRow(
              label: 'Voids',
              value:
                  '${controller.voidsCount}    ${formatReportCurrency(controller.voidsAmount)}',
            ),
            _ReceiptRow(
              label: 'Discounts Given',
              value:
                  '${formatReportCurrency(controller.discountsGivenAmount)}    (${controller.discountBillsCount} bills)',
            ),
            _ReceiptRow(
              label: 'Refunds',
              value:
                  '${formatReportCurrency(controller.refundsAmount)}    (${controller.refundsCount} bills)',
            ),
            const SizedBox(height: 11),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 11),
            const _ReceiptHeading('TENDER BREAKDOWN'),
            const SizedBox(height: 5),
            for (final tender in controller.tenderBreakdown)
              _ReceiptRow(
                label: tender.label,
                value: formatReportCurrency(tender.amount),
              ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xff9A9A9A), height: 1),
            const SizedBox(height: 12),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Thank you for your business!',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'SmartPOS • Grow Together',
                    style: TextStyle(
                      fontSize: 8,
                      color: ReportColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptHeading extends StatelessWidget {
  final String title;

  const _ReceiptHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  final Color? labelColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.w800 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor ?? const Color(0xff303030),
                fontSize: 10,
                fontWeight: weight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? const Color(0xff303030),
                fontSize: 10,
                fontWeight: weight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
