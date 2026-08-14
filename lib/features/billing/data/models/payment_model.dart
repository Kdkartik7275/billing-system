import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/payment_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'payment_model.g.dart';

@HiveType(typeId: HiveTypeIds.paymentModel)
class PaymentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final PaymentMethod method;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String? transactionId;

  @HiveField(4)
  final DateTime? paidAt;

  PaymentModel({
    required this.id,
    required this.method,
    required this.amount,
    this.transactionId,
    this.paidAt,
  });

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      method: entity.method,
      amount: entity.amount,
      transactionId: entity.transactionId,
      paidAt: entity.paidAt,
    );
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      method: method,
      amount: amount,
      transactionId: transactionId,
      paidAt: paidAt,
    );
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      method: PaymentMethod.values.byName(json['method'] as String),
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transactionId'] as String?,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method.name,
      'amount': amount,
      'transactionId': transactionId,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  PaymentModel copyWith({
    String? id,
    PaymentMethod? method,
    double? amount,
    String? transactionId,
    DateTime? paidAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
