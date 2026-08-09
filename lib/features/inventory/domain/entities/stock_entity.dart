enum StockStatus { inStock, lowStock, outOfStock }

class StockEntity {
  final String id;
  final String productId;
  final String warehouseId;
  final String? variantId;

  final double quantity;

  final double reservedQuantity;

  final DateTime lastUpdated;

  const StockEntity({
    required this.id,
    required this.productId,
    required this.warehouseId,
    this.variantId,
    required this.quantity,
    this.reservedQuantity = 0,
    required this.lastUpdated,
  });

  /// Quantity actually available to sell right now.
  double get availableQuantity => quantity - reservedQuantity;

  /// Derives [StockStatus] given the product's configured low-stock
  /// threshold (kept in [ProductSettings], not duplicated here).
  StockStatus statusFor(int lowStockThreshold) {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  StockEntity copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? variantId,
    double? quantity,
    double? reservedQuantity,
    DateTime? lastUpdated,
  }) {
    return StockEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StockEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockEntity(productId: $productId, warehouseId: $warehouseId, qty: $quantity)';
}
