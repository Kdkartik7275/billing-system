class BillItemEntity {
  final String id;

  final String productId;
  final String productName;

  final String sku;
  final String barcode;

  final String? variantId;
  final String? batchId;

  final double quantity;

  final double unitPrice;
  final double mrp;

  final double discount;
  final double taxPercent;
  final double tax;

  final double total;

  const BillItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.barcode,
    this.variantId,
    this.batchId,
    required this.quantity,
    required this.unitPrice,
    required this.mrp,
    required this.discount,
    required this.taxPercent,
    required this.tax,
    required this.total,
  });

  BillItemEntity copyWith({
    String? id,
    String? productId,
    String? productName,
    String? sku,
    String? barcode,
    String? variantId,
    String? batchId,
    double? quantity,
    double? unitPrice,
    double? mrp,
    double? discount,
    double? taxPercent,
    double? tax,
    double? total,
  }) {
    return BillItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      variantId: variantId ?? this.variantId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      mrp: mrp ?? this.mrp,
      discount: discount ?? this.discount,
      taxPercent: taxPercent ?? this.taxPercent,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }
}
