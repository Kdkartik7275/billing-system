import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/product_entity.dart';
import 'product_image_model.dart';
import 'product_price_model.dart';
import 'product_settings_model.dart';
import 'product_tax_model.dart';
import 'product_variant_model.dart';

part 'product_model.g.dart';

@HiveType(typeId: HiveTypeIds.productModel)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String sku;

  @HiveField(4)
  final String barcode;

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final String? brandId;

  @HiveField(7)
  final String unitId;

  @HiveField(8)
  final String? primarySupplierId;

  @HiveField(9)
  final ProductPriceModel price;

  @HiveField(10)
  final ProductTaxModel tax;

  @HiveField(11)
  final ProductSettingsModel settings;

  @HiveField(12)
  final List<ProductVariantModel> variants;

  @HiveField(13)
  final List<ProductImageModel> images;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.sku,
    required this.barcode,
    required this.categoryId,
    this.brandId,
    required this.unitId,
    this.primarySupplierId,
    required this.price,
    required this.tax,
    required this.settings,
    this.variants = const [],
    this.images = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      sku: entity.sku,
      barcode: entity.barcode,
      categoryId: entity.categoryId,
      brandId: entity.brandId,
      unitId: entity.unitId,
      primarySupplierId: entity.primarySupplierId,
      price: ProductPriceModel.fromEntity(entity.price),
      tax: ProductTaxModel.fromEntity(entity.tax),
      settings: ProductSettingsModel.fromEntity(entity.settings),
      variants: entity.variants.map(ProductVariantModel.fromEntity).toList(),
      images: entity.images.map(ProductImageModel.fromEntity).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      sku: sku,
      barcode: barcode,
      categoryId: categoryId,
      brandId: brandId,
      unitId: unitId,
      primarySupplierId: primarySupplierId,
      price: price.toEntity(),
      tax: tax.toEntity(),
      settings: settings.toEntity(),
      variants: variants.map((e) => e.toEntity()).toList(),
      images: images.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      categoryId: json['categoryId'] ?? '',
      brandId: json['brandId'],
      unitId: json['unitId'] ?? '',
      primarySupplierId: json['primarySupplierId'],
      price: ProductPriceModel.fromJson(json['price'] ?? {}),
      tax: ProductTaxModel.fromJson(json['tax'] ?? {}),
      settings: ProductSettingsModel.fromJson(json['settings'] ?? {}),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => ProductVariantModel.fromJson(e))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImageModel.fromJson(e))
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'categoryId': categoryId,
      'brandId': brandId,
      'unitId': unitId,
      'primarySupplierId': primarySupplierId,
      'price': price.toJson(),
      'tax': tax.toJson(),
      'settings': settings.toJson(),
      'variants': variants.map((e) => e.toJson()).toList(),
      'images': images.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unitId,
    String? primarySupplierId,
    ProductPriceModel? price,
    ProductTaxModel? tax,
    ProductSettingsModel? settings,
    List<ProductVariantModel>? variants,
    List<ProductImageModel>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      unitId: unitId ?? this.unitId,
      primarySupplierId: primarySupplierId ?? this.primarySupplierId,
      price: price ?? this.price,
      tax: tax ?? this.tax,
      settings: settings ?? this.settings,
      variants: variants ?? this.variants,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
