import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Standard 80mm thermal receipt width in points (1mm ≈ 2.83pt)
const double _receiptWidth = 80 * PdfPageFormat.mm;

Future<void> printBill({
  required BillEntity bill,
  required ShopEntity shop,
}) async {
  if (bill.items.isEmpty) {
    AppSnackbar.error(message: 'Cannot print an empty bill');
    return;
  }

  final pdf = pw.Document();
  final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(_receiptWidth, double.infinity, marginAll: 12),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // ---------------- SHOP BRANDING ----------------
            pw.Center(
              child: pw.Text(
                shop.shopName,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (shop.address != null) ...[
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  shop.address!,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
            if (shop.ownerPhone != null) ...[
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'Ph: ${shop.ownerPhone}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],

            // if (shop. != null) ...[
            //   pw.SizedBox(height: 2),
            //   pw.Center(
            //     child: pw.Text(
            //       'GSTIN: ${shop.gstin}',
            //       style: const pw.TextStyle(fontSize: 9),
            //     ),
            //   ),
            // ],
            pw.SizedBox(height: 8),
            _dashedDivider(),
            pw.SizedBox(height: 6),

            // ---------------- BILL META ----------------
            _metaRow('Bill No', bill.billNumber),
            _metaRow('Date', dateFormat.format(bill.createdAt)),
            _metaRow('Cashier', bill.cashierId),
            if (bill.customer != null)
              _metaRow('Customer', bill.customer!.name),

            pw.SizedBox(height: 6),
            _dashedDivider(),
            pw.SizedBox(height: 4),

            // ---------------- ITEMS HEADER ----------------
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 5,
                  child: pw.Text(
                    'Item',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Qty',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Rate',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Amount',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 4),
            _dashedDivider(),
            pw.SizedBox(height: 4),

            // ---------------- ITEMS ----------------
            for (final item in bill.items) ...[
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text(
                      item.productName,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      item.quantity % 1 == 0
                          ? item.quantity.toStringAsFixed(0)
                          : item.quantity.toStringAsFixed(2),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      item.unitPrice.toStringAsFixed(2),
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      item.total.toStringAsFixed(2),
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
              if (item.taxPercent > 0)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 1),
                  child: pw.Text(
                    '  GST ${item.taxPercent.toStringAsFixed(0)}% incl.',
                    style: pw.TextStyle(
                      fontSize: 7.5,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              pw.SizedBox(height: 4),
            ],

            _dashedDivider(),
            pw.SizedBox(height: 6),

            // ---------------- TOTALS ----------------
            _totalRow('Subtotal', bill.subTotal),
            if (bill.discount > 0) _totalRow('Discount', -bill.discount),
            _totalRow('Tax (GST)', bill.tax),

            pw.SizedBox(height: 4),
            _dashedDivider(),
            pw.SizedBox(height: 4),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Grand Total',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Rs. ${bill.grandTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 8),
            _dashedDivider(),
            pw.SizedBox(height: 6),

            // ---------------- PAYMENT SUMMARY ----------------
            for (final payment in bill.payment.payments)
              _totalRow(
                _paymentMethodLabel(payment.method.name),
                payment.amount,
              ),
            if (bill.payment.changeAmount > 0)
              _totalRow('Change Returned', bill.payment.changeAmount),

            pw.SizedBox(height: 10),
            _dashedDivider(),
            pw.SizedBox(height: 8),

            // ---------------- FOOTER ----------------
            pw.Center(
              child: pw.Text(
                'Thank you for shopping with us!',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Center(
              child: pw.Text(
                'Items once sold cannot be returned',
                style: const pw.TextStyle(
                  fontSize: 7.5,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
    name: 'bill_${bill.billNumber}.pdf',
  );
}

// ---------------- HELPERS ----------------

pw.Widget _dashedDivider() {
  return pw.Row(
    children: List.generate(
      60,
      (index) => pw.Expanded(
        child: pw.Container(
          height: 0.7,
          color: index.isEven ? PdfColors.grey700 : PdfColors.white,
        ),
      ),
    ),
  );
}

pw.Widget _metaRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
      ],
    ),
  );
}

pw.Widget _totalRow(String label, double value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9.5)),
        pw.Text(
          '${value < 0 ? '- ' : ''}Rs. ${value.abs().toStringAsFixed(2)}',
          style: const pw.TextStyle(fontSize: 9.5),
        ),
      ],
    ),
  );
}

String _paymentMethodLabel(String methodName) {
  switch (methodName) {
    case 'cash':
      return 'Paid (Cash)';
    case 'card':
      return 'Paid (Card)';
    case 'upi':
      return 'Paid (UPI)';
    case 'wallet':
      return 'Paid (Wallet)';
    default:
      return 'Paid (Other)';
  }
}
