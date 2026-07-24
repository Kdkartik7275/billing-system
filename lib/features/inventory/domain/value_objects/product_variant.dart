/// A single attribute/value pair that differentiates one variant of a
/// product from another, e.g. ("Size", "1L") or ("Color", "Red").
class VariantAttribute {
  final String name;
  final String value;

  const VariantAttribute({required this.name, required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariantAttribute && other.name == name && other.value == value);

  @override
  int get hashCode => Object.hash(name, value);

  @override
  String toString() => '$name: $value';
}

/// Value object representing one purchasable variant of a product
/// (e.g. a specific pack size or flavor of "Coca Cola").
///
/// Embedded as a list inside [ProductEntity]. A product with no variations
/// simply has a single default [ProductVariant] (or an empty list, handled
/// by [ProductEntity.hasVariants]).
class ProductVariant {
  final String id;
  final String sku;
  final String? barcode;
  final List<VariantAttribute> attributes;

  /// Optional price override for this specific variant. When null, the
  /// parent [ProductEntity]'s base [ProductPrice] applies.
  final double? sellingPriceOverride;

  final bool isActive;

  const ProductVariant({
    required this.id,
    required this.sku,
    this.barcode,
    this.attributes = const [],
    this.sellingPriceOverride,
    this.isActive = true,
  });

  /// Human-readable label built from attributes, e.g. "1L / Red".
  String get displayLabel =>
      attributes.isEmpty ? sku : attributes.map((a) => a.value).join(' / ');

  ProductVariant copyWith({
    String? id,
    String? sku,
    String? barcode,
    List<VariantAttribute>? attributes,
    double? sellingPriceOverride,
    bool? isActive,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      attributes: attributes ?? this.attributes,
      sellingPriceOverride: sellingPriceOverride ?? this.sellingPriceOverride,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductVariant && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductVariant(id: $id, label: $displayLabel)';
}
