class PurchasePaymentEntity {
  final String id;

  final String purchaseId;

  final String supplierId;

  final double amount;

  final DateTime paymentDate;

  final String paymentMethod;

  final String? referenceNumber;

  final String? notes;

  final DateTime createdAt;

  const PurchasePaymentEntity({
    required this.id,
    required this.purchaseId,
    required this.supplierId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
  });

  PurchasePaymentEntity copyWith({
    String? id,
    String? purchaseId,
    String? supplierId,
    double? amount,
    DateTime? paymentDate,
    String? paymentMethod,
    String? referenceNumber,
    String? notes,
    DateTime? createdAt,
  }) {
    return PurchasePaymentEntity(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      supplierId: supplierId ?? this.supplierId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'PurchasePaymentEntity('
        'id: $id, '
        'purchaseId: $purchaseId, '
        'supplierId: $supplierId, '
        'amount: $amount, '
        'paymentDate: $paymentDate, '
        'paymentMethod: $paymentMethod'
        ')';
  }
}
