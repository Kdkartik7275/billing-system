import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/value_objects/product_settings.dart';

part 'product_settings_model.g.dart';

@HiveType(typeId: HiveTypeIds.productSettingsModel)
class ProductSettingsModel extends HiveObject {
  @HiveField(0)
  final int lowStockThreshold;

  @HiveField(1)
  final bool allowNegativeStock;

  @HiveField(2)
  final bool isActive;

  @HiveField(3)
  final bool trackBatches;

  @HiveField(4)
  final bool trackExpiry;

  @HiveField(5)
  final bool isLoyaltyEligible;

  ProductSettingsModel({
    this.lowStockThreshold = 10,
    this.allowNegativeStock = false,
    this.isActive = true,
    this.trackBatches = false,
    this.trackExpiry = false,
    this.isLoyaltyEligible = true,
  });

  factory ProductSettingsModel.fromEntity(ProductSettings entity) {
    return ProductSettingsModel(
      lowStockThreshold: entity.lowStockThreshold,
      allowNegativeStock: entity.allowNegativeStock,
      isActive: entity.isActive,
      trackBatches: entity.trackBatches,
      trackExpiry: entity.trackExpiry,
      isLoyaltyEligible: entity.isLoyaltyEligible,
    );
  }

  ProductSettings toEntity() {
    return ProductSettings(
      lowStockThreshold: lowStockThreshold,
      allowNegativeStock: allowNegativeStock,
      isActive: isActive,
      trackBatches: trackBatches,
      trackExpiry: trackExpiry,
      isLoyaltyEligible: isLoyaltyEligible,
    );
  }

  factory ProductSettingsModel.fromJson(Map<String, dynamic> json) {
    return ProductSettingsModel(
      lowStockThreshold: json['lowStockThreshold'] ?? 10,
      allowNegativeStock: json['allowNegativeStock'] ?? false,
      isActive: json['isActive'] ?? true,
      trackBatches: json['trackBatches'] ?? false,
      trackExpiry: json['trackExpiry'] ?? false,
      isLoyaltyEligible: json['isLoyaltyEligible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lowStockThreshold': lowStockThreshold,
      'allowNegativeStock': allowNegativeStock,
      'isActive': isActive,
      'trackBatches': trackBatches,
      'trackExpiry': trackExpiry,
      'isLoyaltyEligible': isLoyaltyEligible,
    };
  }

  ProductSettingsModel copyWith({
    int? lowStockThreshold,
    bool? allowNegativeStock,
    bool? isActive,
    bool? trackBatches,
    bool? trackExpiry,
    bool? isLoyaltyEligible,
  }) {
    return ProductSettingsModel(
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      isActive: isActive ?? this.isActive,
      trackBatches: trackBatches ?? this.trackBatches,
      trackExpiry: trackExpiry ?? this.trackExpiry,
      isLoyaltyEligible: isLoyaltyEligible ?? this.isLoyaltyEligible,
    );
  }
}
