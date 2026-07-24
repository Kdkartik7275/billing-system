/// How GST/tax is applied to a product's [ProductPrice.sellingPrice].
enum TaxType {
  /// Selling price does not include tax; tax is added on top at billing.
  exclusive,

  /// Selling price already includes tax.
  inclusive,

  /// Product is tax-exempt (e.g. certain unbranded staples).
  exempt,
}

/// Value object holding GST/tax configuration for a product.
///
/// Embedded inside [ProductEntity] — tax rules have no independent
/// lifecycle of their own for a single product.
class ProductTax {
  /// GST percentage, e.g. 5, 12, 18, 28. Ignored when [type] is [TaxType.exempt].
  final double gstPercent;
  final TaxType type;

  /// HSN (Harmonized System of Nomenclature) code, required for GST filing
  /// on most goods above the turnover threshold.
  final String? hsnCode;

  const ProductTax({
    this.gstPercent = 0,
    this.type = TaxType.exclusive,
    this.hsnCode,
  });

  const ProductTax.exempt({this.hsnCode})
      : gstPercent = 0,
        type = TaxType.exempt;

  bool get isExempt => type == TaxType.exempt;

  /// Computes the tax amount for a given base [sellingPrice].
  double taxAmountFor(double sellingPrice) {
    if (isExempt || gstPercent == 0) return 0;
    if (type == TaxType.inclusive) {
      // Price already includes tax: back-calculate the tax component.
      return sellingPrice - (sellingPrice / (1 + gstPercent / 100));
    }
    return sellingPrice * (gstPercent / 100);
  }

  /// Final price a customer pays, inclusive of tax, given a base [sellingPrice].
  double finalPriceFor(double sellingPrice) {
    if (isExempt) return sellingPrice;
    if (type == TaxType.inclusive) return sellingPrice;
    return sellingPrice + taxAmountFor(sellingPrice);
  }

  ProductTax copyWith({
    double? gstPercent,
    TaxType? type,
    String? hsnCode,
  }) {
    return ProductTax(
      gstPercent: gstPercent ?? this.gstPercent,
      type: type ?? this.type,
      hsnCode: hsnCode ?? this.hsnCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductTax &&
          other.gstPercent == gstPercent &&
          other.type == type &&
          other.hsnCode == hsnCode);

  @override
  int get hashCode => Object.hash(gstPercent, type, hsnCode);

  @override
  String toString() => 'ProductTax(gst: $gstPercent%, type: $type)';
}
