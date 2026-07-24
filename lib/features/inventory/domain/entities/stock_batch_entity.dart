/// A single received lot/batch of a product at a warehouse, used for
/// FEFO (first-expiry-first-out) picking and expiry tracking.
///
/// Only created/consulted when [ProductSettings.trackBatches] is enabled
/// on the product. Several [StockBatchEntity] rows can sum up to the
/// aggregate [StockEntity.quantity] for the same product+warehouse.
class StockBatchEntity {
  final String id;
  final String productId;
  final String warehouseId;
  final String batchNumber;
  final double quantity;
  final DateTime? manufactureDate;
  final DateTime? expiryDate;

  /// Purchase price for this specific batch — can differ from the
  /// product's current [ProductPrice.purchasePrice] if costs changed
  /// between purchases.
  final double purchasePrice;

  final DateTime receivedAt;

  const StockBatchEntity({
    required this.id,
    required this.productId,
    required this.warehouseId,
    required this.batchNumber,
    required this.quantity,
    this.manufactureDate,
    this.expiryDate,
    required this.purchasePrice,
    required this.receivedAt,
  });

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  /// True when the batch expires within the given [withinDays] window
  /// (defaults to 30), used to surface "expiring soon" alerts.
  bool isExpiringSoon({int withinDays = 30}) {
    if (expiryDate == null) return false;
    final cutoff = DateTime.now().add(Duration(days: withinDays));
    return expiryDate!.isBefore(cutoff) && !isExpired;
  }

  StockBatchEntity copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? batchNumber,
    double? quantity,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    double? purchasePrice,
    DateTime? receivedAt,
  }) {
    return StockBatchEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      batchNumber: batchNumber ?? this.batchNumber,
      quantity: quantity ?? this.quantity,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StockBatchEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockBatchEntity(id: $id, batch: $batchNumber, qty: $quantity)';
}
