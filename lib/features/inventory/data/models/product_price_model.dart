import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/value_objects/product_price.dart';

part 'product_price_model.g.dart';

@HiveType(typeId: HiveTypeIds.productPriceModel)
class ProductPriceModel extends HiveObject {
  @HiveField(0)
  final double purchasePrice;

  @HiveField(1)
  final double sellingPrice;

  @HiveField(2)
  final double? mrp;

  @HiveField(3)
  final double? wholesalePrice;

  ProductPriceModel({
    required this.purchasePrice,
    required this.sellingPrice,
    this.mrp,
    this.wholesalePrice,
  });

  factory ProductPriceModel.fromEntity(ProductPrice entity) {
    return ProductPriceModel(
      purchasePrice: entity.purchasePrice,
      sellingPrice: entity.sellingPrice,
      mrp: entity.mrp,
      wholesalePrice: entity.wholesalePrice,
    );
  }

  ProductPrice toEntity() {
    return ProductPrice(
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      mrp: mrp,
      wholesalePrice: wholesalePrice,
    );
  }

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) {
    return ProductPriceModel(
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      mrp: json['mrp'] != null ? (json['mrp'] as num).toDouble() : null,
      wholesalePrice: json['wholesalePrice'] != null
          ? (json['wholesalePrice'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'mrp': mrp,
      'wholesalePrice': wholesalePrice,
    };
  }

  ProductPriceModel copyWith({
    double? purchasePrice,
    double? sellingPrice,
    double? mrp,
    double? wholesalePrice,
  }) {
    return ProductPriceModel(
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
    );
  }
}
