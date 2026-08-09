enum TaxType { exclusive, inclusive, exempt }

class ProductTax {
  final double gstPercent;
  final TaxType type;

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

  ProductTax copyWith({double? gstPercent, TaxType? type, String? hsnCode}) {
    return ProductTax(
      gstPercent: gstPercent ?? this.gstPercent,
      type: type ?? this.type,
      hsnCode: hsnCode ?? this.hsnCode,
    );
  }
}
