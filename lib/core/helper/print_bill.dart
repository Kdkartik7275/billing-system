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
      pageFormat: PdfPageFormat(_receiptWidth, double.infinity, marginAll: 14),
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
                  fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Center(
              child: pw.Text(
                shop.address,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Center(
              child: pw.Text(
                'Ph: ${shop.ownerPhone}',
                style: pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
              ),
            ),
            if (shop.businessDetails.gstNumber != null) ...[
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'GSTIN: ${shop.businessDetails.gstNumber}',
                  style: pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
                ),
              ),
            ],

            pw.SizedBox(height: 10),
            _solidDivider(),
            pw.SizedBox(height: 8),

            // ---------------- BILL META ----------------
            _metaRow('Bill No', bill.billNumber, emphasize: true),
            _metaRow('Date', dateFormat.format(bill.createdAt)),
            _metaRow('Cashier', bill.cashierId),
            if (bill.customer != null)
              _metaRow('Customer', bill.customer!.name),

            pw.SizedBox(height: 10),
            _dashedDivider(),
            pw.SizedBox(height: 8),

            // ---------------- ITEMS ----------------
            _sectionLabel('ITEMS (${bill.items.length})'),
            pw.SizedBox(height: 6),

            pw.Row(
              children: [
                _headerCell('Item', flex: 5),
                _headerCell('Qty', flex: 2, align: pw.TextAlign.center),
                _headerCell('Rate', flex: 3, align: pw.TextAlign.right),
                _headerCell('Amount', flex: 3, align: pw.TextAlign.right),
              ],
            ),

            pw.SizedBox(height: 4),
            _dashedDivider(),
            pw.SizedBox(height: 5),

            for (final item in bill.items) ...[
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (item.taxPercent > 0)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 1.5),
                  child: pw.Text(
                    'GST ${item.taxPercent.toStringAsFixed(0)}% incl.',
                    style: pw.TextStyle(
                      fontSize: 7.5,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              pw.SizedBox(height: 6),
            ],

            pw.SizedBox(height: 2),
            _dashedDivider(),
            pw.SizedBox(height: 10),

            // ---------------- TOTALS (boxed) ----------------
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                children: [
                  _totalRow('Subtotal', bill.subTotal),
                  if (bill.discount > 0) _totalRow('Discount', -bill.discount),
                  if (bill.tax > 0) _totalRow('Tax (GST)', bill.tax),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5),
                    child: _solidDivider(color: PdfColors.grey400),
                  ),
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
                ],
              ),
            ),

            pw.SizedBox(height: 10),
            _dashedDivider(),
            pw.SizedBox(height: 8),

            // ---------------- PAYMENT SUMMARY ----------------
            _sectionLabel('PAYMENT'),
            pw.SizedBox(height: 6),
            for (final payment in bill.payment.payments)
              _totalRow(
                _paymentMethodLabel(payment.method.name),
                payment.amount,
              ),
            if (bill.payment.changeAmount > 0)
              _totalRow('Change Returned', bill.payment.changeAmount),

            pw.SizedBox(height: 12),
            _dashedDivider(),
            pw.SizedBox(height: 12),

            // ---------------- INVOICE QR ----------------
            pw.Center(
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: bill.billNumber,
                width: 46,
                height: 46,
                drawText: false,
              ),
            ),

            pw.SizedBox(height: 12),
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
                style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
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

pw.Widget _solidDivider({PdfColor color = PdfColors.grey800}) {
  return pw.Container(height: 0.9, color: color);
}

pw.Widget _sectionLabel(String text) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey600,
      letterSpacing: 0.6,
    ),
  );
}

pw.Widget _headerCell(
  String text, {
  required int flex,
  pw.TextAlign align = pw.TextAlign.left,
}) {
  return pw.Expanded(
    flex: flex,
    child: pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
    ),
  );
}

pw.Widget _metaRow(String label, String value, {bool emphasize = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: emphasize ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
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
