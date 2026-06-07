import 'package:flutter/material.dart';

class ScanEntry {
  final String barcode;
  final String? productName;
  final String? productId;
  final bool success;
  final TimeOfDay time;

  const ScanEntry({
    required this.barcode,
    this.productName,
    this.productId,
    required this.success,
    required this.time,
  });
}