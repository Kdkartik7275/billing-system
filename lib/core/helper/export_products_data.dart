import 'dart:typed_data';

import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProductExportRow {
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final String? brand;
  final String unit;
  final double purchasePrice;
  final double sellingPrice;
  final double stockQuantity;
  final StockStatus stockStatus;
  final bool isActive;

  const ProductExportRow({
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    this.brand,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.stockStatus,
    required this.isActive,
  });

  double get inventoryValue => purchasePrice * stockQuantity;
}

/// Result of building a product export PDF: the raw bytes plus a
/// suggested filename. Callers decide how to persist/share it —
/// this class stays platform-agnostic (no dart:io, no path_provider)
/// so it works identically on mobile, desktop, and web.
class ProductExportResult {
  final Uint8List bytes;
  final String fileName;

  const ProductExportResult({required this.bytes, required this.fileName});
}

class ProductPdfExporter {
  const ProductPdfExporter();

  static const _currencyPrefix = 'Rs. ';
  static final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  /// Builds the PDF and returns it as bytes. No filesystem access here —
  /// safe to call on any platform including web.
  Future<ProductExportResult> export({
    required List<ProductExportRow> rows,
    String title = 'Product Inventory Report',
    String? shopName,
  }) async {
    final doc = pw.Document();
    final generatedAt = DateTime.now();

    final totalValue = rows.fold<double>(0, (sum, r) => sum + r.inventoryValue);
    final lowStockCount = rows
        .where((r) => r.stockStatus == StockStatus.lowStock)
        .length;
    final outOfStockCount = rows
        .where((r) => r.stockStatus == StockStatus.outOfStock)
        .length;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 32),
        header: (context) => _buildHeader(
          title: title,
          shopName: shopName,
          generatedAt: generatedAt,
          showFull: context.pageNumber == 1,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummaryRow(
            totalProducts: rows.length,
            totalValue: totalValue,
            lowStockCount: lowStockCount,
            outOfStockCount: outOfStockCount,
          ),
          pw.SizedBox(height: 16),
          _buildTable(rows),
        ],
      ),
    );

    final bytes = await doc.save();
    final fileName =
        'product_export_${DateFormat('yyyyMMdd_HHmmss').format(generatedAt)}.pdf';
    return ProductExportResult(bytes: bytes, fileName: fileName);
  }

  // ---------------- HEADER / FOOTER ----------------

  pw.Widget _buildHeader({
    required String title,
    String? shopName,
    required DateTime generatedAt,
    required bool showFull,
  }) {
    if (!showFull) {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(
          title,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (shopName != null) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    shopName,
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ],
            ),
            pw.Text(
              'Generated: ${_dateFormat.format(generatedAt)}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey400, thickness: 0.8),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
      ),
    );
  }

  // ---------------- SUMMARY ----------------

  pw.Widget _buildSummaryRow({
    required int totalProducts,
    required double totalValue,
    required int lowStockCount,
    required int outOfStockCount,
  }) {
    return pw.Row(
      children: [
        _summaryTile('Total Products', '$totalProducts', PdfColors.blue700),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Inventory Value',
          '$_currencyPrefix${_formatNumber(totalValue)}',
          PdfColors.green700,
        ),
        pw.SizedBox(width: 10),
        _summaryTile('Low Stock', '$lowStockCount', PdfColors.orange700),
        pw.SizedBox(width: 10),
        _summaryTile('Out of Stock', '$outOfStockCount', PdfColors.red700),
      ],
    );
  }

  // Uses ClipRRect + Row instead of Border(left:) + borderRadius —
  // the pdf package only allows borderRadius on a uniform Border,
  // so a left-only accent strip needs to be drawn this way instead.
  pw.Widget _summaryTile(String label, String value, PdfColor accent) {
    const tileHeight = 46.0;

    return pw.Expanded(
      child: pw.ClipRRect(
        horizontalRadius: 6,
        verticalRadius: 6,
        child: pw.Container(
          height: tileHeight,
          color: PdfColors.grey100,
          child: pw.Row(
            children: [
              pw.Container(width: 3, height: tileHeight, color: accent),
              pw.Expanded(
                child: pw.Container(
                  height: tileHeight,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        label,
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        value,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: accent,
                        ),
                      ),
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

  // ---------------- TABLE ----------------

  static const List<String> _headers = [
    'Product',
    'SKU',
    'Category',
    'Brand',
    'Unit',
    'Purchase',
    'Selling',
    'Stock',
    'Status',
  ];

  pw.Widget _buildTable(List<ProductExportRow> rows) {
    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: const pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.6),
        1: pw.FlexColumnWidth(1.4),
        2: pw.FlexColumnWidth(1.6),
        3: pw.FlexColumnWidth(1.4),
        4: pw.FlexColumnWidth(0.9),
        5: pw.FlexColumnWidth(1.2),
        6: pw.FlexColumnWidth(1.2),
        7: pw.FlexColumnWidth(0.9),
        8: pw.FlexColumnWidth(1.3),
      },
      children: [
        _buildHeaderRow(),
        for (var i = 0; i < rows.length; i++) _buildDataRow(rows[i], i),
      ],
    );
  }

  pw.TableRow _buildHeaderRow() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey800),
      children: _headers
          .map(
            (h) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 8,
              ),
              child: pw.Text(
                h,
                style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  pw.TableRow _buildDataRow(ProductExportRow row, int index) {
    final statusColor = switch (row.stockStatus) {
      StockStatus.inStock => PdfColors.green700,
      StockStatus.lowStock => PdfColors.orange700,
      StockStatus.outOfStock => PdfColors.red700,
    };
    final statusLabel = switch (row.stockStatus) {
      StockStatus.inStock => 'In Stock',
      StockStatus.lowStock => 'Low Stock',
      StockStatus.outOfStock => 'Out of Stock',
    };

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: index.isEven ? PdfColors.white : PdfColors.grey50,
      ),
      children: [
        _cell(row.name, bold: true, dimmed: !row.isActive),
        _cell(row.sku),
        _cell(row.category),
        _cell(row.brand ?? '—'),
        _cell(row.unit),
        _cell('$_currencyPrefix${_formatNumber(row.purchasePrice)}'),
        _cell('$_currencyPrefix${_formatNumber(row.sellingPrice)}'),
        _cell(_formatNumber(row.stockQuantity)),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: pw.BoxDecoration(
              color: statusColor,
              borderRadius: pw.BorderRadius.circular(3),
            ),
            child: pw.Text(
              statusLabel,
              style: const pw.TextStyle(fontSize: 7, color: PdfColors.white),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false, bool dimmed = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: dimmed ? PdfColors.grey500 : PdfColors.black,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }
}
