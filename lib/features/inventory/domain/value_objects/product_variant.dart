class VariantAttribute {
  final String name;
  final String value;

  const VariantAttribute({required this.name, required this.value});
}

class ProductVariant {
  final String id;
  final String sku;
  final String? barcode;
  final List<VariantAttribute> attributes;

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

  
}
