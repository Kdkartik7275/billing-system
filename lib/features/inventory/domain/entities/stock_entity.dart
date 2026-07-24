/// Coarse-grained status derived from a [StockEntity]'s quantity versus its
/// product's low-stock threshold. Computed, never stored.
enum StockStatus { inStock, lowStock, outOfStock }

/// Tracks the current on-hand quantity of one product at one warehouse.
///
/// Deliberately separate from [ProductEntity]: a product's catalog data
/// (name, price, tax) changes rarely, while stock quantity changes on
/// every sale/purchase/transfer. Keeping them apart avoids rewriting the
/// whole catalog record on every stock movement and allows the same
/// product to have independent stock rows per [WarehouseEntity].
///
/// Batch/expiry-level detail (when [ProductSettings.trackBatches] is true)
/// lives in [StockBatchEntity]; this entity always reflects the aggregate
/// total across all batches for quick lookups.
class StockEntity {
  final String id;
  final String productId;
  final String warehouseId;
  final String? variantId;

  /// Current total quantity on hand, aggregated across all batches.
  final double quantity;

  /// Quantity reserved against unfulfilled orders/holds — not available
  /// for new sales even though it's still physically on the shelf.
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
