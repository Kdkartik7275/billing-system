/// Why a [StockMovementEntity] happened. Used for filtering the audit
/// trail and for reporting (e.g. shrinkage from [adjustment]/[damaged]).
enum StockMovementType {
  purchaseIn,
  saleOut,
  transferIn,
  transferOut,
  adjustment,
  returnIn,
  returnOut,
  damaged,
  expired,
}

/// An immutable, append-only audit record of a single stock change.
///
/// Every mutation to a [StockEntity]'s quantity — from a purchase, a sale,
/// a transfer between warehouses, or a manual correction — should be
/// accompanied by writing one of these. This is what makes stock levels
/// auditable/explainable after the fact, independent of the current
/// snapshot held in [StockEntity].
class StockMovementEntity {
  final String id;
  final String productId;
  final String warehouseId;
  final String? variantId;
  final String? batchId;

  final StockMovementType type;

  /// Signed quantity delta: positive for stock coming in, negative for
  /// stock going out.
  final double quantityChange;

  /// Stock quantity immediately after this movement was applied —
  /// a running snapshot that makes historical reconstruction cheap.
  final double resultingQuantity;

  /// Free-text reason, mainly used for [StockMovementType.adjustment].
  final String? reason;

  /// Id of the source document that caused this movement, e.g. a purchase
  /// or bill id — kept generic since the inventory module doesn't own
  /// those entities.
  final String? referenceId;

  final String? performedByUserId;
  final DateTime createdAt;

  const StockMovementEntity({
    required this.id,
    required this.productId,
    required this.warehouseId,
    this.variantId,
    this.batchId,
    required this.type,
    required this.quantityChange,
    required this.resultingQuantity,
    this.reason,
    this.referenceId,
    this.performedByUserId,
    required this.createdAt,
  });

  bool get isInbound => quantityChange > 0;
  bool get isOutbound => quantityChange < 0;

  StockMovementEntity copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? variantId,
    String? batchId,
    StockMovementType? type,
    double? quantityChange,
    double? resultingQuantity,
    String? reason,
    String? referenceId,
    String? performedByUserId,
    DateTime? createdAt,
  }) {
    return StockMovementEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      variantId: variantId ?? this.variantId,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      quantityChange: quantityChange ?? this.quantityChange,
      resultingQuantity: resultingQuantity ?? this.resultingQuantity,
      reason: reason ?? this.reason,
      referenceId: referenceId ?? this.referenceId,
      performedByUserId: performedByUserId ?? this.performedByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovementEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockMovementEntity(id: $id, type: $type, change: $quantityChange)';
}
