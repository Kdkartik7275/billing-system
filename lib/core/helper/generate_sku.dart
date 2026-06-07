import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:flutter/material.dart';

String generateSku({
  required String category,
  required String productName,
  required int sequence,
}) {
  final categoryPrefix = _categoryCode(category);

  final words = productName
      .trim()
      .split(' ')
      .where((e) => e.isNotEmpty)
      .toList();

  String productPrefix = '';

  if (words.length >= 3) {
    productPrefix = '${words[0][0]}${words[1][0]}${words[2][0]}'.toUpperCase();
  } else if (words.length == 2) {
    productPrefix =
        '${words[0][0]}${words[1][0]}${words[1].length > 1 ? words[1][1] : 'X'}'
            .toUpperCase();
  } else {
    productPrefix = words.first
        .substring(0, words.first.length >= 3 ? 3 : words.first.length)
        .toUpperCase();
  }

  return '$categoryPrefix-$productPrefix-${sequence.toString().padLeft(3, '0')}';
}

String _categoryCode(String category) {
  switch (category) {
    case 'Fruits & Vegetables':
      return 'FV';
    case 'Dairy':
      return 'DY';
    case 'Bakery':
      return 'BK';
    case 'Grocery':
      return 'GR';
    case 'Beverages':
      return 'BV';
    case 'Snacks':
      return 'SN';
    default:
      return 'OT';
  }
}

int getNextSkuSequence(String category, List<InventoryProduct> products) {
  return products.where((p) => p.category == category).length + 1;
}

String categoryFromSku(String sku) {
  final prefix = sku.split('-').first;

  switch (prefix) {
    case 'FV':
      return 'Fruits & Vegetables';
    case 'DY':
      return 'Dairy';
    case 'BK':
      return 'Bakery';
    case 'GR':
      return 'Grocery';
    case 'BV':
      return 'Beverages';
    case 'SN':
      return 'Snacks';
    default:
      return 'Others';
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Grocery':
      return Colors.blue;

    case 'Fruits & Vegetables':
      return Colors.green;

    case 'Dairy':
      return Colors.orange;

    case 'Beverages':
      return Colors.red;

    case 'Bakery':
      return Colors.purple;

    case 'Snacks':
      return Colors.teal;

    default:
      return Colors.grey;
  }
}
