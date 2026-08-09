import '../value_objects/product_image.dart';
import '../value_objects/product_price.dart';
import '../value_objects/product_settings.dart';
import '../value_objects/product_tax.dart';
import '../value_objects/product_variant.dart';

class ProductEntity {
  final String id;
  final String name;
  final String? description;
  final String sku;
  final String barcode;

  final String categoryId;
  final String? brandId;
  final String unitId;
  final String? primarySupplierId;

  final ProductPrice price;
  final ProductTax tax;
  final ProductSettings settings;
  final List<ProductVariant> variants;
  final List<ProductImage> images;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
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
    this.tax = const ProductTax(),
    this.settings = const ProductSettings(),
    this.variants = const [],
    this.images = const [],
    required this.createdAt,
    this.updatedAt,
  });

  bool get hasVariants => variants.length > 1;

  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    return images
        .firstWhere((img) => img.isPrimary, orElse: () => images.first)
        .url;
  }

  double get finalSellingPrice => tax.finalPriceFor(price.sellingPrice);

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unitId,
    String? primarySupplierId,
    ProductPrice? price,
    ProductTax? tax,
    ProductSettings? settings,
    List<ProductVariant>? variants,
    List<ProductImage>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
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

  bool isSameRecordAs(ProductEntity other) => other.id == id;

  @override
  String toString() => 'ProductEntity(id: $id, name: $name, sku: $sku)';
}
