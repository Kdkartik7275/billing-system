import 'dart:typed_data';

import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Which calendar grain a sales export covers.
///
/// The grain is not cosmetic: it decides how the per-period breakdown table
/// is bucketed. A weekly report buckets by day, a monthly report buckets by
/// ISO week, and a custom range buckets by day when it is short enough to
/// stay readable and by week otherwise.
enum SalesExportPeriod { weekly, monthly, custom }

/// A resolved, inclusive date range plus the label that should appear on the
/// report.
///
/// Both bounds are normalised here rather than at the call site so every
/// entry point (preset menu, custom picker, a future scheduled export)
/// produces the same day-inclusive window: `start` snaps to 00:00:00.000 and
/// `end` snaps to 23:59:59.999. Passing a raw `DateTime.now()` as `end` would
/// silently drop every bill created later in the same day.
class SalesExportRange {
  final DateTime start;
  final DateTime end;
  final SalesExportPeriod period;
  final String label;

  SalesExportRange({
    required DateTime start,
    required DateTime end,
    required this.period,
    required this.label,
  }) : start = DateTime(start.year, start.month, start.day),
       end = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

  /// Monday-to-Sunday week containing [reference].
  ///
  /// `DateTime.weekday` is 1 for Monday, so subtracting `weekday - 1` days
  /// always lands on that week's Monday regardless of the reference day.
  factory SalesExportRange.week(DateTime reference, {int weeksAgo = 0}) {
    final anchor = DateTime(
      reference.year,
      reference.month,
      reference.day,
    ).subtract(Duration(days: 7 * weeksAgo));
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    final fmt = DateFormat('dd MMM yyyy');
    return SalesExportRange(
      start: monday,
      end: sunday,
      period: SalesExportPeriod.weekly,
      label: '${fmt.format(monday)} - ${fmt.format(sunday)}',
    );
  }

  /// Calendar month containing [reference], offset backwards by [monthsAgo].
  ///
  /// Day 0 of month N+1 is the last day of month N, which avoids hardcoding
  /// month lengths and handles leap years for free.
  factory SalesExportRange.month(DateTime reference, {int monthsAgo = 0}) {
    final firstOfTarget = DateTime(
      reference.year,
      reference.month - monthsAgo,
      1,
    );
    final lastOfTarget = DateTime(
      firstOfTarget.year,
      firstOfTarget.month + 1,
      0,
    );

    return SalesExportRange(
      start: firstOfTarget,
      end: lastOfTarget,
      period: SalesExportPeriod.monthly,
      label: DateFormat('MMMM yyyy').format(firstOfTarget),
    );
  }

  /// User-picked range from a date-range picker.
  factory SalesExportRange.custom(DateTime start, DateTime end) {
    final fmt = DateFormat('dd MMM yyyy');
    return SalesExportRange(
      start: start,
      end: end,
      period: SalesExportPeriod.custom,
      label: '${fmt.format(start)} - ${fmt.format(end)}',
    );
  }

  int get dayCount => end.difference(start).inDays + 1;

  /// Filename-safe slug for the range, e.g. `20260824_20260830`.
  String get fileSlug {
    final fmt = DateFormat('yyyyMMdd');
    return '${fmt.format(start)}_${fmt.format(end)}';
  }

  /// True when [date] falls inside the range. Used instead of comparing raw
  /// `DateTime`s at the call site so the inclusive-end rule lives in one place.
  bool contains(DateTime date) => !date.isBefore(start) && !date.isAfter(end);
}

/// Raw PDF bytes plus a suggested filename.
///
/// Deliberately holds bytes rather than a `File`: this class must stay free of
/// `dart:io` and `path_provider` so the same export path works on Android,
/// iOS, desktop, and web. The caller decides how to persist or share it
/// (`Printing.sharePdf` handles all four).
class SalesExportResult {
  final Uint8List bytes;
  final String fileName;

  const SalesExportResult({required this.bytes, required this.fileName});
}

/// One row of the bill-level table.
class SalesExportRow {
  final String billNumber;
  final DateTime createdAt;
  final int itemCount;
  final double quantity;
  final double subTotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final String paymentLabel;
  final BillStatus status;

  const SalesExportRow({
    required this.billNumber,
    required this.createdAt,
    required this.itemCount,
    required this.quantity,
    required this.subTotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.paymentLabel,
    required this.status,
  });

  /// Only completed sales count towards revenue. Cancelled and refunded bills
  /// are still listed — an auditor needs to see them — but they must never be
  /// summed into totals, which is what `countsTowardsRevenue` guards.
  bool get countsTowardsRevenue => status == BillStatus.completed;

  factory SalesExportRow.fromBill(BillEntity bill) {
    final quantity = bill.items.fold<double>(0, (sum, i) => sum + i.quantity);

    return SalesExportRow(
      billNumber: bill.billNumber,
      createdAt: bill.createdAt,
      itemCount: bill.items.length,
      quantity: quantity,
      subTotal: bill.subTotal,
      discount: bill.discount,
      tax: bill.tax,
      grandTotal: bill.grandTotal,
      paymentLabel: _paymentLabelFor(bill),
      status: bill.status,
    );
  }

  /// A bill can be split across several tenders, so the label is built from
  /// every distinct method on the payment summary rather than assuming one.
  static String _paymentLabelFor(BillEntity bill) {
    final methods = bill.payment.payments
        .map((p) => p.method)
        .toSet()
        .map(_methodLabel)
        .toList();

    if (methods.isEmpty) return '-';
    if (methods.length == 1) return methods.first;
    // Joined tightly rather than as "Split (Cash + UPI)" so a split tender
    // still fits the payment column on one line.
    return methods.join('+');
  }

  static String _methodLabel(PaymentMethod method) {
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
}

/// Builds a paginated sales report PDF.
///
/// Mirrors `ProductPdfExporter` on purpose — same header, footer, summary
/// tiles, and zebra table treatment — so the two exports look like they came
/// from the same product.
class SalesPdfExporter {
  const SalesPdfExporter();

  static const _currencyPrefix = 'Rs. ';
  static final _generatedFormat = DateFormat('dd MMM yyyy, hh:mm a');
  // 24-hour time, deliberately. `hh:mm a` pushed "07:42 AM" past the width of
  // the date column in the dense bill table and wrapped onto a second line.
  static final _billDateFormat = DateFormat('dd MMM, HH:mm');
  static final _dayFormat = DateFormat('EEE, dd MMM');
  static final _shortDayFormat = DateFormat('dd MMM');

  /// Builds the report and returns it as bytes. No filesystem access, so this
  /// is safe to call on every platform including web.
  Future<SalesExportResult> export({
    required List<SalesExportRow> rows,
    required SalesExportRange range,
    String? shopName,
    String? paymentFilterLabel,
  }) async {
    final doc = pw.Document();
    final generatedAt = DateTime.now();

    final revenueRows = rows.where((r) => r.countsTowardsRevenue).toList();

    final totalSales = revenueRows.fold<double>(
      0,
      (sum, r) => sum + r.grandTotal,
    );
    final totalTax = revenueRows.fold<double>(0, (sum, r) => sum + r.tax);
    final totalDiscount = revenueRows.fold<double>(
      0,
      (sum, r) => sum + r.discount,
    );
    final totalItems = revenueRows.fold<double>(
      0,
      (sum, r) => sum + r.quantity,
    );
    final averageBill = revenueRows.isEmpty
        ? 0.0
        : totalSales / revenueRows.length;
    final excludedCount = rows.length - revenueRows.length;

    final title = switch (range.period) {
      SalesExportPeriod.weekly => 'Weekly Sales Report',
      SalesExportPeriod.monthly => 'Monthly Sales Report',
      SalesExportPeriod.custom => 'Sales Report',
    };

    // Newest-last inside the document reads better for an audit trail than the
    // newest-first order the on-screen list uses.
    final orderedRows = [...rows]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 32),
        header: (context) => _buildHeader(
          title: title,
          shopName: shopName,
          range: range,
          paymentFilterLabel: paymentFilterLabel,
          generatedAt: generatedAt,
          showFull: context.pageNumber == 1,
        ),
        footer: _buildFooter,
        build: (context) => [
          _buildSummaryRow(
            billCount: revenueRows.length,
            totalSales: totalSales,
            totalItems: totalItems,
            averageBill: averageBill,
          ),
          pw.SizedBox(height: 10),
          _buildSecondarySummaryRow(
            totalTax: totalTax,
            totalDiscount: totalDiscount,
            excludedCount: excludedCount,
            dayCount: range.dayCount,
          ),
          pw.SizedBox(height: 18),
          _sectionTitle(_breakdownTitleFor(range)),
          pw.SizedBox(height: 6),
          _buildBreakdownTable(revenueRows, range),
          pw.SizedBox(height: 18),
          _sectionTitle('Payment Method Breakdown'),
          pw.SizedBox(height: 6),
          _buildPaymentTable(revenueRows, totalSales),
          pw.SizedBox(height: 18),
          _sectionTitle(
            'All Bills (${orderedRows.length})',
            note: 'amounts in ${_currencyPrefix.trim()}',
          ),
          pw.SizedBox(height: 6),
          if (orderedRows.isEmpty)
            _emptyNote('No bills were recorded in this period.')
          else
            _buildBillTable(orderedRows),
        ],
      ),
    );

    final bytes = await doc.save();
    final prefix = switch (range.period) {
      SalesExportPeriod.weekly => 'sales_weekly',
      SalesExportPeriod.monthly => 'sales_monthly',
      SalesExportPeriod.custom => 'sales_report',
    };

    return SalesExportResult(
      bytes: bytes,
      fileName: '${prefix}_${range.fileSlug}.pdf',
    );
  }

  // ---------------- HEADER / FOOTER ----------------

  pw.Widget _buildHeader({
    required String title,
    String? shopName,
    required SalesExportRange range,
    String? paymentFilterLabel,
    required DateTime generatedAt,
    required bool showFull,
  }) {
    if (!showFull) {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(
          '$title  -  ${range.label}',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
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
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  range.label,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Generated: ${_generatedFormat.format(generatedAt)}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
                if (paymentFilterLabel != null) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Payment filter: $paymentFilterLabel',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ],
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
    required int billCount,
    required double totalSales,
    required double totalItems,
    required double averageBill,
  }) {
    return pw.Row(
      children: [
        // Named "Completed Bills" rather than "Total Bills" because this
        // count excludes cancelled and refunded bills, which the bill table
        // below still lists — the two numbers differ on purpose.
        _summaryTile('Completed Bills', '$billCount', PdfColors.blue700),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Total Sales',
          '$_currencyPrefix${_formatNumber(totalSales)}',
          PdfColors.green700,
        ),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Items Sold',
          _formatNumber(totalItems),
          PdfColors.purple700,
        ),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Avg. Bill Value',
          '$_currencyPrefix${_formatNumber(averageBill)}',
          PdfColors.orange700,
        ),
      ],
    );
  }

  pw.Widget _buildSecondarySummaryRow({
    required double totalTax,
    required double totalDiscount,
    required int excludedCount,
    required int dayCount,
  }) {
    return pw.Row(
      children: [
        _summaryTile(
          'Tax Collected',
          '$_currencyPrefix${_formatNumber(totalTax)}',
          PdfColors.teal700,
        ),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Discount Given',
          '$_currencyPrefix${_formatNumber(totalDiscount)}',
          PdfColors.indigo700,
        ),
        pw.SizedBox(width: 10),
        _summaryTile('Days Covered', '$dayCount', PdfColors.grey700),
        pw.SizedBox(width: 10),
        _summaryTile(
          'Cancelled / Refunded',
          '$excludedCount',
          PdfColors.red700,
        ),
      ],
    );
  }

  // Uses ClipRRect + Row instead of Border(left:) + borderRadius, because the
  // pdf package only allows borderRadius on a uniform Border — a left-only
  // accent strip has to be drawn as a sibling container.
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

  pw.Widget _sectionTitle(String text, {String? note}) {
    final title = pw.Text(
      text,
      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
    );

    if (note == null) return title;

    // The bill table drops the currency prefix from every cell to keep the
    // money columns on one line, so the unit is stated once here instead.
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        title,
        pw.SizedBox(width: 8),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 1),
          child: pw.Text(
            note,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ),
      ],
    );
  }

  pw.Widget _emptyNote(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
      ),
    );
  }

  // ---------------- PERIOD BREAKDOWN ----------------

  String _breakdownTitleFor(SalesExportRange range) {
    if (range.period == SalesExportPeriod.monthly) {
      return 'Week-by-Week Breakdown';
    }
    if (range.period == SalesExportPeriod.custom && range.dayCount > 31) {
      return 'Week-by-Week Breakdown';
    }
    return 'Day-by-Day Breakdown';
  }

  /// True when the breakdown should bucket by week rather than by day.
  ///
  /// A 31-day day-by-day table is fine; a 6-month one is not, which is why the
  /// custom range flips to weekly past 31 days.
  bool _bucketByWeek(SalesExportRange range) {
    if (range.period == SalesExportPeriod.monthly) return true;
    if (range.period == SalesExportPeriod.custom && range.dayCount > 31) {
      return true;
    }
    return false;
  }

  pw.Widget _buildBreakdownTable(
    List<SalesExportRow> revenueRows,
    SalesExportRange range,
  ) {
    final byWeek = _bucketByWeek(range);

    // Buckets are pre-seeded for every day/week in the range so a zero-sales
    // day still appears as a row. A missing row reads as "no data recorded",
    // which is a very different business signal from "we sold nothing".
    final buckets = <DateTime, List<SalesExportRow>>{};

    if (byWeek) {
      var cursor = range.start.subtract(
        Duration(days: range.start.weekday - 1),
      );
      while (!cursor.isAfter(range.end)) {
        buckets[cursor] = [];
        cursor = cursor.add(const Duration(days: 7));
      }
    } else {
      for (var i = 0; i < range.dayCount; i++) {
        buckets[range.start.add(Duration(days: i))] = [];
      }
    }

    for (final row in revenueRows) {
      final day = DateTime(
        row.createdAt.year,
        row.createdAt.month,
        row.createdAt.day,
      );
      final key = byWeek ? day.subtract(Duration(days: day.weekday - 1)) : day;
      // `putIfAbsent` covers the edge case where a bill's timestamp sits just
      // outside the seeded buckets (for example a bill created a second before
      // midnight on the boundary day after a clock change).
      buckets.putIfAbsent(key, () => []).add(row);
    }

    final keys = buckets.keys.toList()..sort();

    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: const pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.2),
        1: pw.FlexColumnWidth(1.0),
        2: pw.FlexColumnWidth(1.0),
        3: pw.FlexColumnWidth(1.4),
        4: pw.FlexColumnWidth(1.4),
      },
      children: [
        _headerRow(const [
          'Period',
          'Bills',
          'Items',
          'Sales',
          'Avg. Bill',
        ], numericFrom: 1),
        for (final key in keys)
          _breakdownDataRow(
            key,
            buckets[key]!,
            byWeek,
            keys.indexOf(key),
            range,
          ),
      ],
    );
  }

  pw.TableRow _breakdownDataRow(
    DateTime key,
    List<SalesExportRow> rows,
    bool byWeek,
    int index,
    SalesExportRange range,
  ) {
    final sales = rows.fold<double>(0, (sum, r) => sum + r.grandTotal);
    final items = rows.fold<double>(0, (sum, r) => sum + r.quantity);
    final avg = rows.isEmpty ? 0.0 : sales / rows.length;

    String label;
    if (byWeek) {
      // Clamp the displayed week to the requested range so a monthly report
      // does not advertise days from the neighbouring month.
      final weekStart = key.isBefore(range.start) ? range.start : key;
      final rawEnd = key.add(const Duration(days: 6));
      final weekEnd = rawEnd.isAfter(range.end) ? range.end : rawEnd;
      label =
          '${_shortDayFormat.format(weekStart)} - '
          '${_shortDayFormat.format(weekEnd)}';
    } else {
      label = _dayFormat.format(key);
    }

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: index.isEven ? PdfColors.white : PdfColors.grey50,
      ),
      children: [
        _cell(label, bold: true, dimmed: rows.isEmpty),
        _cell('${rows.length}', align: pw.TextAlign.right),
        _cell(_formatNumber(items), align: pw.TextAlign.right),
        _cell(
          '$_currencyPrefix${_formatNumber(sales)}',
          align: pw.TextAlign.right,
        ),
        _cell(
          '$_currencyPrefix${_formatNumber(avg)}',
          align: pw.TextAlign.right,
        ),
      ],
    );
  }

  // ---------------- PAYMENT BREAKDOWN ----------------

  pw.Widget _buildPaymentTable(
    List<SalesExportRow> revenueRows,
    double totalSales,
  ) {
    final byMethod = <String, List<SalesExportRow>>{};
    for (final row in revenueRows) {
      byMethod.putIfAbsent(row.paymentLabel, () => []).add(row);
    }

    if (byMethod.isEmpty) {
      return _emptyNote('No completed payments in this period.');
    }

    final entries = byMethod.entries.toList()
      ..sort((a, b) {
        final aTotal = a.value.fold<double>(0, (s, r) => s + r.grandTotal);
        final bTotal = b.value.fold<double>(0, (s, r) => s + r.grandTotal);
        return bTotal.compareTo(aTotal);
      });

    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: const pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.6),
        1: pw.FlexColumnWidth(1.0),
        2: pw.FlexColumnWidth(1.6),
        3: pw.FlexColumnWidth(1.0),
      },
      children: [
        _headerRow(const [
          'Payment Method',
          'Bills',
          'Amount',
          'Share',
        ], numericFrom: 1),
        for (var i = 0; i < entries.length; i++)
          _paymentDataRow(entries[i], i, totalSales),
      ],
    );
  }

  pw.TableRow _paymentDataRow(
    MapEntry<String, List<SalesExportRow>> entry,
    int index,
    double totalSales,
  ) {
    final amount = entry.value.fold<double>(0, (sum, r) => sum + r.grandTotal);
    // Guard the divide: an all-zero-value period would otherwise produce NaN%.
    final share = totalSales <= 0 ? 0.0 : (amount / totalSales) * 100;

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: index.isEven ? PdfColors.white : PdfColors.grey50,
      ),
      children: [
        _cell(entry.key, bold: true),
        _cell('${entry.value.length}', align: pw.TextAlign.right),
        _cell(
          '$_currencyPrefix${_formatNumber(amount)}',
          align: pw.TextAlign.right,
        ),
        _cell('${share.toStringAsFixed(1)}%', align: pw.TextAlign.right),
      ],
    );
  }

  // ---------------- BILL TABLE ----------------

  pw.Widget _buildBillTable(List<SalesExportRow> rows) {
    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: const pw.BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
      // Widths are tuned against real rendered output: the money columns are
      // sized for an 8-digit amount and the status column for the longest
      // pill label ("Cancelled") without wrapping.
      columnWidths: const {
        0: pw.FlexColumnWidth(1.65),
        1: pw.FlexColumnWidth(1.55),
        2: pw.FlexColumnWidth(0.7),
        3: pw.FlexColumnWidth(1.15),
        4: pw.FlexColumnWidth(1.15),
        5: pw.FlexColumnWidth(1.1),
        6: pw.FlexColumnWidth(1.2),
        7: pw.FlexColumnWidth(1.45),
        8: pw.FlexColumnWidth(1.35),
      },
      children: [
        _headerRow(
          const [
            'Invoice',
            'Date & Time',
            'Qty',
            'Subtotal',
            'Discount',
            'Tax',
            'Total',
            'Payment',
            'Status',
          ],
          numericFrom: 2,
          numericTo: 6,
        ),
        for (var i = 0; i < rows.length; i++) _billDataRow(rows[i], i),
      ],
    );
  }

  pw.TableRow _billDataRow(SalesExportRow row, int index) {
    final statusColor = switch (row.status) {
      BillStatus.completed => PdfColors.green700,
      BillStatus.pending => PdfColors.orange700,
      BillStatus.cancelled => PdfColors.red700,
      BillStatus.refunded => PdfColors.blueGrey700,
    };
    final statusLabel = switch (row.status) {
      BillStatus.completed => 'Completed',
      BillStatus.pending => 'Pending',
      BillStatus.cancelled => 'Cancelled',
      BillStatus.refunded => 'Refunded',
    };

    final dimmed = !row.countsTowardsRevenue;

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: index.isEven ? PdfColors.white : PdfColors.grey50,
      ),
      children: [
        _cell(row.billNumber, bold: true, dimmed: dimmed),
        _cell(_billDateFormat.format(row.createdAt), dimmed: dimmed),
        _cell(
          _formatNumber(row.quantity),
          align: pw.TextAlign.right,
          dimmed: dimmed,
        ),
        // No currency prefix in this table — see the section note. Repeating
        // "Rs. " in four columns forced every amount onto two lines.
        _cell(
          _formatNumber(row.subTotal),
          align: pw.TextAlign.right,
          dimmed: dimmed,
        ),
        _cell(
          // A dash reads faster than "0" when scanning for the bills that
          // actually carried a discount.
          row.discount == 0 ? '-' : _formatNumber(row.discount),
          align: pw.TextAlign.right,
          dimmed: dimmed,
        ),
        _cell(
          row.tax == 0 ? '-' : _formatNumber(row.tax),
          align: pw.TextAlign.right,
          dimmed: dimmed,
        ),
        _cell(
          _formatNumber(row.grandTotal),
          align: pw.TextAlign.right,
          bold: true,
          dimmed: dimmed,
        ),
        _cell(row.paymentLabel, dimmed: dimmed),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              decoration: pw.BoxDecoration(
                color: statusColor,
                borderRadius: pw.BorderRadius.circular(3),
              ),
              child: pw.Text(
                statusLabel,
                maxLines: 1,
                softWrap: false,
                style: const pw.TextStyle(
                  fontSize: 6.5,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- SHARED TABLE PIECES ----------------

  pw.TableRow _headerRow(
    List<String> headers, {
    int numericFrom = -1,
    int? numericTo,
  }) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey800),
      children: [
        for (var i = 0; i < headers.length; i++)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: pw.Text(
              headers[i],
              textAlign:
                  numericFrom >= 0 &&
                      i >= numericFrom &&
                      i <= (numericTo ?? headers.length - 1)
                  ? pw.TextAlign.right
                  : pw.TextAlign.left,
              style: pw.TextStyle(
                fontSize: 8.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
      ],
    );
  }

  pw.Widget _cell(
    String text, {
    bool bold = false,
    bool dimmed = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
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
