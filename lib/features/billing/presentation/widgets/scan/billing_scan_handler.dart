import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/scan/billing_multi_scan_page.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';

class BillingScanHandler {
  // ---------------- ENTRY POINT ----------------

  static Future<void> scanAndAddToCart({
    required BuildContext context,
    required InventoryController inventoryController,
    required CartController cartController,
  }) async {
    final result = await Navigator.push<List<ScannedLineItem>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BillingMultiScanPage(inventoryController: inventoryController),
      ),
    );

    if (result == null || result.isEmpty) return;

    for (final line in result) {
      for (int i = 0; i < line.count; i++) {
        cartController.addToCart(line.product);
      }
    }
  }
}
