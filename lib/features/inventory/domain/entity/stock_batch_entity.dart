class StockBatch {
  final String id;

  final String productId;

  final int quantityRemaining;

  final double purchasePrice;

  final double sellingPrice;

  final DateTime receivedDate;

  StockBatch({
    required this.id,
    required this.productId,
    required this.quantityRemaining,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.receivedDate,
  });

  StockBatch copyWith({
    String? id,
    String? productId,
    int? quantityRemaining,
    double? purchasePrice,
    double? sellingPrice,
    DateTime? receivedDate,
  }) {
    return StockBatch(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      receivedDate: receivedDate ?? this.receivedDate,
    );
  }
}
