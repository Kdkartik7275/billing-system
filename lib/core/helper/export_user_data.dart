import 'package:billing_system/core/config/theme/pdf_fonts.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportAccountData({
  required UserEntity user,
  required ShopEntity shop,
}) async {
  final pdf = pw.Document(theme: await PdfFonts.theme());
  final dateFmt = DateFormat('dd MMM yyyy');
  final dateTimeFmt = DateFormat('dd MMM yyyy, hh:mm a');
  final now = DateTime.now();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER ----------------
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      shop.shopName,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Account Data Export',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  'Generated ${dateFmt.format(now)}',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),

            pw.SizedBox(height: 16),
            pw.Container(height: 1.2, color: PdfColors.grey800),
            pw.SizedBox(height: 24),

            // ---------------- ACCOUNT OWNER ----------------
            _section(
              'ACCOUNT OWNER',
              _fieldGrid([
                MapEntry('Name', user.name),
                MapEntry('Role', _roleLabel(user.role)),
                MapEntry('Email', user.email),
                MapEntry('Phone', user.phone),
                MapEntry('Status', user.isActive ? 'Active' : 'Inactive'),
                MapEntry('Member Since', dateFmt.format(user.createdAt)),
                MapEntry('Last Login', dateTimeFmt.format(user.lastLogin)),
              ]),
            ),

            // ---------------- SHOP DETAILS ----------------
            _section(
              'SHOP DETAILS',
              _fieldGrid([
                MapEntry('Shop Name', shop.shopName),
                MapEntry('Status', shop.isActive ? 'Active' : 'Inactive'),
                MapEntry('Address', shop.address),
                MapEntry('Plan', shop.plan),
                if (shop.subscriptionExpiry != null)
                  MapEntry(
                    'Subscription Expiry',
                    dateFmt.format(shop.subscriptionExpiry!),
                  ),
                MapEntry('Shop Created', dateFmt.format(shop.createdAt)),
              ]),
            ),

            // ---------------- BUSINESS DETAILS ----------------
            _section(
              'BUSINESS DETAILS',
              _fieldGrid([
                MapEntry('GST Number', shop.businessDetails.gstNumber ?? '—'),
                MapEntry('PAN Number', shop.businessDetails.panNumber ?? '—'),
                MapEntry(
                  'Business Type',
                  shop.businessDetails.businessType ?? '—',
                ),
                MapEntry('State', shop.businessDetails.state ?? '—'),
                MapEntry(
                  'FSSAI License',
                  shop.businessDetails.fssaiLicense ?? '—',
                ),
                MapEntry('Currency', shop.businessDetails.currency),
                MapEntry(
                  'Financial Year Start',
                  shop.businessDetails.financialYearStart,
                ),
              ]),
            ),

            pw.Spacer(),
            pw.Container(height: 0.8, color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.Text(
              'This document contains your account information as stored '
              'in SmartPOS. Login credentials and system configuration '
              'keys are never included in this export.',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
    name: 'account_data_${user.uid}.pdf',
  );
}

// ---------------- HELPERS ----------------

pw.Widget _section(String title, pw.Widget child) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey700,
          letterSpacing: 0.6,
        ),
      ),
      pw.SizedBox(height: 12),
      child,
      pw.SizedBox(height: 22),
    ],
  );
}

pw.Widget _fieldGrid(List<MapEntry<String, String>> fields) {
  final rows = <pw.TableRow>[];

  for (var i = 0; i < fields.length; i += 2) {
    final left = fields[i];
    final right = i + 1 < fields.length ? fields[i + 1] : null;

    rows.add(
      pw.TableRow(
        children: [
          _fieldCell(left.key, left.value),
          right != null ? _fieldCell(right.key, right.value) : pw.SizedBox(),
        ],
      ),
    );
  }

  return pw.Table(
    columnWidths: const {0: pw.FlexColumnWidth(), 1: pw.FlexColumnWidth()},
    children: rows,
  );
}

pw.Widget _fieldCell(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 14, right: 16),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8.5,
            color: PdfColors.grey600,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(value, style: const pw.TextStyle(fontSize: 10.5)),
      ],
    ),
  );
}

String _roleLabel(UserRole role) {
  switch (role) {
    case UserRole.owner:
      return 'Owner';
    case UserRole.manager:
      return 'Manager';
    case UserRole.cashier:
      return 'Cashier';
  }
}
