class ProductPrice {
  final double purchasePrice;

  final double sellingPrice;

  final double? mrp;

  final double? wholesalePrice;

  const ProductPrice({
    required this.purchasePrice,
    required this.sellingPrice,
    this.mrp,
    this.wholesalePrice,
  });

  double get profitPerUnit => sellingPrice - purchasePrice;

  double get marginPercent =>
      purchasePrice == 0 ? 0 : (profitPerUnit / purchasePrice) * 100;

  double? get discountOffMrpPercent {
    if (mrp == null || mrp == 0) return null;
    return ((mrp! - sellingPrice) / mrp!) * 100;
  }

  ProductPrice copyWith({
    double? purchasePrice,
    double? sellingPrice,
    double? mrp,
    double? wholesalePrice,
  }) {
    return ProductPrice(
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
    );
  }
}
