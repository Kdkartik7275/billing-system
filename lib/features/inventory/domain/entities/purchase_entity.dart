class PurchaseEntity {
  final String id;

  final String productId;
  final String supplierId;
  final String warehouseId;

  final String invoiceNumber;

  final DateTime purchaseDate;
  final DateTime billDate;

  final int quantity;
  final double price;

  final double discount;
  final double tax;

  final String paymentMethod;
  final DateTime dueDate;

  final String batchNumber;
  final String? notes;

  const PurchaseEntity({
    required this.id,
    required this.productId,
    required this.supplierId,
    required this.warehouseId,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.billDate,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.tax,
    required this.paymentMethod,
    required this.dueDate,
    required this.batchNumber,
    this.notes,
  });

  PurchaseEntity copyWith({
    String? id,
    String? productId,
    String? supplierId,
    String? warehouseId,
    String? invoiceNumber,
    DateTime? purchaseDate,
    DateTime? billDate,
    int? quantity,
    double? price,
    double? discount,
    double? tax,
    String? paymentMethod,
    DateTime? dueDate,
    String? batchNumber,
    String? notes,
  }) {
    return PurchaseEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      warehouseId: warehouseId ?? this.warehouseId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      billDate: billDate ?? this.billDate,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      dueDate: dueDate ?? this.dueDate,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
    );
  }

  double get subtotal => quantity * price;

  double get taxableAmount => subtotal - discount;

  double get totalAmount => taxableAmount + tax;

  double get dueAmount => totalAmount;

  @override
  String toString() {
    return 'PurchaseEntity('
        'id: $id, '
        'invoiceNumber: $invoiceNumber, '
        'productId: $productId, '
        'supplierId: $supplierId, '
        'quantity: $quantity'
        ')';
  }
}
