import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:flutter/material.dart';

extension StockTransactionTypeX on StockTransactionType {
  bool get isIncoming =>
      this == StockTransactionType.purchase ||
      this == StockTransactionType.initialStock ||
      this == StockTransactionType.returnStock;

  Color get color {
    switch (this) {
      case StockTransactionType.purchase:
        return const Color(0xFF16A34A);
      case StockTransactionType.initialStock:
        return const Color(0xFF2563EB);
      case StockTransactionType.returnStock:
        return const Color(0xFF0891B2);
      case StockTransactionType.sale:
        return const Color(0xFFEA580C);
      case StockTransactionType.damage:
        return const Color(0xFFDC2626);
      case StockTransactionType.adjustment:
        return const Color(0xFF7C3AED);
    }
  }

  Color get bgColor {
    switch (this) {
      case StockTransactionType.purchase:
        return const Color(0xFFDCFCE7);
      case StockTransactionType.initialStock:
        return const Color(0xFFDBEAFE);
      case StockTransactionType.returnStock:
        return const Color(0xFFCFFAFE);
      case StockTransactionType.sale:
        return const Color(0xFFFFF7ED);
      case StockTransactionType.damage:
        return const Color(0xFFFEE2E2);
      case StockTransactionType.adjustment:
        return const Color(0xFFEDE9FE);
    }
  }

  IconData get icon {
    switch (this) {
      case StockTransactionType.purchase:
        return Icons.arrow_downward_rounded;
      case StockTransactionType.initialStock:
        return Icons.inventory_2_outlined;
      case StockTransactionType.returnStock:
        return Icons.keyboard_return_rounded;
      case StockTransactionType.sale:
        return Icons.arrow_upward_rounded;
      case StockTransactionType.damage:
        return Icons.broken_image_outlined;
      case StockTransactionType.adjustment:
        return Icons.tune_rounded;
    }
  }

  String get label {
    switch (this) {
      case StockTransactionType.purchase:
        return 'Purchase';
      case StockTransactionType.initialStock:
        return 'Initial Stock';
      case StockTransactionType.returnStock:
        return 'Return';
      case StockTransactionType.sale:
        return 'Sale';
      case StockTransactionType.damage:
        return 'Damage';
      case StockTransactionType.adjustment:
        return 'Adjustment';
    }
  }

  String get sheetTitle {
    switch (this) {
      case StockTransactionType.purchase:
        return 'Record Purchase';
      case StockTransactionType.initialStock:
        return 'Set Initial Stock';
      case StockTransactionType.returnStock:
        return 'Record Return';
      case StockTransactionType.sale:
        return 'Record Sale';
      case StockTransactionType.damage:
        return 'Record Damage';
      case StockTransactionType.adjustment:
        return 'Stock Adjustment';
    }
  }
}
