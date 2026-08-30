import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:billing_system/core/scanner/barcode_scanner_page.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<File?> pickImage({bool camera = false}) async {
  ImagePicker picker = ImagePicker();
  XFile? pickedFile = await picker.pickImage(
    source: camera ? ImageSource.camera : ImageSource.gallery,
  );
  if (pickedFile == null) return null;
  return File(pickedFile.path);
}

Future<String?> scanBarcode({
  String title = 'Scan Barcode',
  String instructionText = 'Align the barcode within the frame',
}) async {
  final result = await Get.to<String>(
    () => BarcodeScannerPage(title: title, instructionText: instructionText),
  );

  if (result == null || result.trim().isEmpty) return null;
  return result.trim();
}

Future<void> printBarcode(String barcode) async {
  if (barcode.isEmpty) {
    AppSnackbar.error(message: 'Enter or scan a barcode before printing');
    return;
  }

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a6,
      margin: const pw.EdgeInsets.all(16),
      build: (context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'Product Barcode',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 24),

              // Barcode
              pw.BarcodeWidget(
                barcode: pw.Barcode.code128(),
                data: barcode,
                width: 220,
                height: 80,
                drawText: false,
              ),

              pw.SizedBox(height: 12),

              // Human readable text
              pw.Text(
                barcode,
                style: const pw.TextStyle(fontSize: 16, letterSpacing: 2),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
    name: 'barcode_$barcode.pdf',
  );
}

const List<Color> _categoryPalette = [
  Color(0xff2962FF),
  Color(0xff2E7D32),
  Color(0xffEF6C00),
  Color(0xff6A1B9A),
  Color(0xffD32F2F),
  Color(0xff00838F),
  Color(0xffAD1457),
  Color(0xff5D4037),
];

Color categoryColor(String category) {
  final hash = category.codeUnits.fold(0, (sum, unit) => sum + unit);
  return _categoryPalette[hash % _categoryPalette.length];
}

String generateId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);

  final random = Random()
      .nextInt(36 * 36 * 36)
      .toRadixString(36)
      .padLeft(3, '0');

  return '$timestamp$random';
}
