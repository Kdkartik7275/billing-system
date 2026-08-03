import 'dart:io';

import 'package:billing_system/core/scanner/barcode_scanner_page.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
