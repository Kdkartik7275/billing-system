/// Value object holding all pricing figures for a product.
///
/// This is intentionally NOT a standalone entity/repository — pricing has
/// no independent lifecycle or identity outside of the product it belongs
/// to, so it's embedded directly inside [ProductEntity].
class ProductPrice {
  /// Price the business paid to acquire the product (per unit).
  final double purchasePrice;

  /// Price the product is sold to customers at (per unit).
  final double sellingPrice;

  /// Optional MRP printed on the package, used for discount display.
  final double? mrp;

  /// Optional wholesale price for bulk buyers.
  final double? wholesalePrice;

  const ProductPrice({
    required this.purchasePrice,
    required this.sellingPrice,
    this.mrp,
    this.wholesalePrice,
  });

  /// Profit margin per unit in currency.
  double get profitPerUnit => sellingPrice - purchasePrice;

  /// Profit margin as a percentage of the purchase price.
  /// Returns 0 when [purchasePrice] is 0 to avoid division errors.
  double get marginPercent =>
      purchasePrice == 0 ? 0 : (profitPerUnit / purchasePrice) * 100;

  /// Discount percentage off the printed MRP, if an MRP is set.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPrice &&
          other.purchasePrice == purchasePrice &&
          other.sellingPrice == sellingPrice &&
          other.mrp == mrp &&
          other.wholesalePrice == wholesalePrice);

  @override
  int get hashCode =>
      Object.hash(purchasePrice, sellingPrice, mrp, wholesalePrice);

  @override
  String toString() =>
      'ProductPrice(purchase: $purchasePrice, selling: $sellingPrice)';
}
