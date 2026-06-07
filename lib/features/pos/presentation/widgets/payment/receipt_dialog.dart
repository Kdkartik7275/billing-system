import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/pos/data/models/payment_result.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptDialog extends StatelessWidget {
  final PaymentResult result;

  const ReceiptDialog({super.key, required this.result});

  static Future<void> show(PaymentResult result) {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => ReceiptDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ReceiptHeader(result: result),
            const _DashedDivider(),
            _ReceiptItemsList(result: result),
            const _DashedDivider(),
            _ReceiptTotals(result: result),
            if (result.method == PaymentMethod.cash) ...[
              const _DashedDivider(),
              _CashSummary(result: result),
            ],
            const _DashedDivider(),
            _ReceiptFooter(result: result),
          ],
        ),
      ),
    );
  }
}

class _ReceiptHeader extends StatelessWidget {
  final PaymentResult result;
  const _ReceiptHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    final time =
        '${result.paidAt.hour.toString().padLeft(2, '0')}:${result.paidAt.minute.toString().padLeft(2, '0')}';
    final date =
        '${result.paidAt.day.toString().padLeft(2, '0')}/${result.paidAt.month.toString().padLeft(2, '0')}/${result.paidAt.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.green.shade700.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.green.shade400,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Payment Successful',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$date  $time',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.receiptNumber,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptItemsList extends StatelessWidget {
  final PaymentResult result;
  const _ReceiptItemsList({required this.result});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shrinkWrap: true,
        itemCount: result.items.length,
        itemBuilder: (_, i) {
          final item = result.items[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'x${item.quantity}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '₹${item.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReceiptTotals extends StatelessWidget {
  final PaymentResult result;
  const _ReceiptTotals({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _TotalRow(label: 'Subtotal', value: result.subtotal),
          const SizedBox(height: 6),
          _TotalRow(label: 'Tax (5%)', value: result.tax),
          const SizedBox(height: 10),
          _TotalRow(
            label: 'Grand Total',
            value: result.grandTotal,
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _TotalRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight ? Colors.black : Colors.black54,
            fontSize: highlight ? 14 : 13,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: highlight ? AppColors.primary : Colors.black54,
            fontSize: highlight ? 15 : 13,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CashSummary extends StatelessWidget {
  final PaymentResult result;
  const _CashSummary({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _TotalRow(label: 'Cash Tendered', value: result.amountTendered),
          const SizedBox(height: 6),
          _TotalRow(label: 'Change', value: result.change, highlight: true),
        ],
      ),
    );
  }
}

class _ReceiptFooter extends StatelessWidget {
  final PaymentResult result;
  const _ReceiptFooter({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: _FooterBtn(
              label: 'Print Receipt',
              icon: Icons.print_rounded,
              onTap: () => _printReceipt(result),
              outlined: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FooterBtn(
              label: 'Done',
              icon: Icons.check_rounded,
              onTap: () {
                Get.find<CartController>().clearCart();
                Get.back();
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt(PaymentResult result) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'RECEIPT',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(child: pw.Text(result.receiptNumber)),
            pw.Divider(),
            ...result.items.map(
              (item) => pw.Row(
                children: [
                  pw.Expanded(child: pw.Text(item.product.name)),
                  pw.Text('x${item.quantity}'),
                  pw.SizedBox(width: 8),
                  pw.Text('Rs.${item.total.toStringAsFixed(2)}'),
                ],
              ),
            ),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Subtotal')),
                pw.Text('Rs.${result.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Tax (5%)')),
                pw.Text('Rs.${result.tax.toStringAsFixed(2)}'),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'Grand Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                  'Rs.${result.grandTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            if (result.method == PaymentMethod.cash) ...[
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text('Cash Tendered')),
                  pw.Text('Rs.${result.amountTendered.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text('Change')),
                  pw.Text('Rs.${result.change.toStringAsFixed(2)}'),
                ],
              ),
            ],
            pw.Divider(),
            pw.Center(child: pw.Text('Thank you!')),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }
}

class _FooterBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  const _FooterBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: outlined ? Border.all(color: Colors.black26) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: outlined ? Colors.black54 : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: outlined ? Colors.black54 : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (_, constraints) {
          const dashWidth = 6.0;
          const dashSpace = 4.0;
          final count = (constraints.maxWidth / (dashWidth + dashSpace))
              .floor();
          return Row(
            children: List.generate(
              count,
              (_) => Container(
                width: dashWidth,
                height: 1,
                margin: const EdgeInsets.only(right: dashSpace),
                color: Colors.black26,
              ),
            ),
          );
        },
      ),
    );
  }
}
