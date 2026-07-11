import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:flutter/material.dart';

extension InventoryProductX on InventoryProduct {
  Color get statusColor {
    switch (status) {
      case StockStatus.inStock:
        return const Color(0xFF16A34A);
      case StockStatus.lowStock:
        return const Color(0xFFEA580C);
      case StockStatus.outOfStock:
        return const Color(0xFFDC2626);
    }
  }

  String get statusLabel {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }
}
