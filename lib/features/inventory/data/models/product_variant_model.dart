import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/value_objects/product_variant.dart';

part 'product_variant_model.g.dart';

@HiveType(typeId: 15)
class VariantAttributeModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String value;

  VariantAttributeModel({required this.name, required this.value});

  factory VariantAttributeModel.fromEntity(VariantAttribute entity) {
    return VariantAttributeModel(name: entity.name, value: entity.value);
  }

  VariantAttribute toEntity() {
    return VariantAttribute(name: name, value: value);
  }

  factory VariantAttributeModel.fromJson(Map<String, dynamic> json) {
    return VariantAttributeModel(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }

  VariantAttributeModel copyWith({String? name, String? value}) {
    return VariantAttributeModel(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}

@HiveType(typeId: 9)
class ProductVariantModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sku;

  @HiveField(2)
  final String? barcode;

  @HiveField(3)
  final List<VariantAttributeModel> attributes;

  @HiveField(4)
  final double? sellingPriceOverride;

  @HiveField(5)
  final bool isActive;

  ProductVariantModel({
    required this.id,
    required this.sku,
    this.barcode,
    this.attributes = const [],
    this.sellingPriceOverride,
    this.isActive = true,
  });

  factory ProductVariantModel.fromEntity(ProductVariant entity) {
    return ProductVariantModel(
      id: entity.id,
      sku: entity.sku,
      barcode: entity.barcode,
      attributes: entity.attributes
          .map(VariantAttributeModel.fromEntity)
          .toList(),
      sellingPriceOverride: entity.sellingPriceOverride,
      isActive: entity.isActive,
    );
  }

  ProductVariant toEntity() {
    return ProductVariant(
      id: id,
      sku: sku,
      barcode: barcode,
      attributes: attributes.map((e) => e.toEntity()).toList(),
      sellingPriceOverride: sellingPriceOverride,
      isActive: isActive,
    );
  }

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      barcode: json['barcode'],
      attributes: (json['attributes'] as List<dynamic>? ?? [])
          .map((e) => VariantAttributeModel.fromJson(e))
          .toList(),
      sellingPriceOverride: json['sellingPriceOverride'] != null
          ? (json['sellingPriceOverride'] as num).toDouble()
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'barcode': barcode,
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'sellingPriceOverride': sellingPriceOverride,
      'isActive': isActive,
    };
  }

  ProductVariantModel copyWith({
    String? id,
    String? sku,
    String? barcode,
    List<VariantAttributeModel>? attributes,
    double? sellingPriceOverride,
    bool? isActive,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      attributes: attributes ?? this.attributes,
      sellingPriceOverride: sellingPriceOverride ?? this.sellingPriceOverride,
      isActive: isActive ?? this.isActive,
    );
  }
}
