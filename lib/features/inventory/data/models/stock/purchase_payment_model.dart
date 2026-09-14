import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_payment_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'purchase_payment_model.g.dart';

@HiveType(typeId: HiveTypeIds.purchasePaymentModel)
class PurchasePaymentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String purchaseId;

  @HiveField(2)
  final String supplierId;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime paymentDate;

  @HiveField(5)
  final String paymentMethod;

  @HiveField(6)
  final String? referenceNumber;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final DateTime createdAt;

  PurchasePaymentModel({
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

  factory PurchasePaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchasePaymentModel(
      id: json['id'] as String,
      purchaseId: json['purchaseId'] as String,
      supplierId: json['supplierId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(
        json['paymentDate'] as String,
      ),
      paymentMethod: json['paymentMethod'] as String,
      referenceNumber:
          json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseId': purchaseId,
      'supplierId': supplierId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'referenceNumber': referenceNumber,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PurchasePaymentModel.fromEntity(
    PurchasePaymentEntity entity,
  ) {
    return PurchasePaymentModel(
      id: entity.id,
      purchaseId: entity.purchaseId,
      supplierId: entity.supplierId,
      amount: entity.amount,
      paymentDate: entity.paymentDate,
      paymentMethod: entity.paymentMethod,
      referenceNumber: entity.referenceNumber,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  PurchasePaymentEntity toEntity() {
    return PurchasePaymentEntity(
      id: id,
      purchaseId: purchaseId,
      supplierId: supplierId,
      amount: amount,
      paymentDate: paymentDate,
      paymentMethod: paymentMethod,
      referenceNumber: referenceNumber,
      notes: notes,
      createdAt: createdAt,
    );
  }

  PurchasePaymentModel copyWith({
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
    return PurchasePaymentModel(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      supplierId: supplierId ?? this.supplierId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber:
          referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'PurchasePaymentModel('
        'id: $id, '
        'purchaseId: $purchaseId, '
        'supplierId: $supplierId, '
        'amount: $amount'
        ')';
  }
}