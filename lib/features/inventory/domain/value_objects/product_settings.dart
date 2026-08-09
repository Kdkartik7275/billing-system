class ProductSettings {
  final int lowStockThreshold;

  final bool allowNegativeStock;

  final bool isActive;

  final bool trackBatches;

  final bool trackExpiry;

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
}
