/// Behavioral flags/thresholds for a product — embedded in [ProductEntity].
///
/// These control how the product behaves in stock alerts, POS billing and
/// catalog visibility, without needing their own table/repository.
class ProductSettings {
  /// Stock level at or below which the product is flagged "Low Stock".
  final int lowStockThreshold;

  /// Whether this product can be sold when stock is zero (backorder).
  final bool allowNegativeStock;

  /// Whether the product is shown in the POS/catalog search.
  final bool isActive;

  /// Whether stock/expiry is tracked per-batch (see [StockBatchEntity]).
  final bool trackBatches;

  /// Whether this product requires a batch/lot expiry date to be sellable.
  final bool trackExpiry;

  /// Whether this product participates in loyalty point calculations.
  final bool isLoyaltyEligible;

  const ProductSettings({
    this.lowStockThreshold = 10,
    this.allowNegativeStock = false,
    this.isActive = true,
    this.trackBatches = false,
    this.trackExpiry = false,
    this.isLoyaltyEligible = true,
  });

  ProductSettings copyWith({
    int? lowStockThreshold,
    bool? allowNegativeStock,
    bool? isActive,
    bool? trackBatches,
    bool? trackExpiry,
    bool? isLoyaltyEligible,
  }) {
    return ProductSettings(
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      isActive: isActive ?? this.isActive,
      trackBatches: trackBatches ?? this.trackBatches,
      trackExpiry: trackExpiry ?? this.trackExpiry,
      isLoyaltyEligible: isLoyaltyEligible ?? this.isLoyaltyEligible,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductSettings &&
          other.lowStockThreshold == lowStockThreshold &&
          other.allowNegativeStock == allowNegativeStock &&
          other.isActive == isActive &&
          other.trackBatches == trackBatches &&
          other.trackExpiry == trackExpiry &&
          other.isLoyaltyEligible == isLoyaltyEligible);

  @override
  int get hashCode => Object.hash(
        lowStockThreshold,
        allowNegativeStock,
        isActive,
        trackBatches,
        trackExpiry,
        isLoyaltyEligible,
      );

  @override
  String toString() => 'ProductSettings(lowStockThreshold: $lowStockThreshold)';
}
