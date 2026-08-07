import 'package:billing_system/features/billing/data/models/payment_model.dart';
import 'package:billing_system/features/billing/domain/entities/payment_summary_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'payment_summary_model.g.dart';

@HiveType(typeId: 25)
class PaymentSummaryModel {
  @HiveField(0)
  final List<PaymentModel> payments;

  @HiveField(1)
  final double paidAmount;

  @HiveField(2)
  final double changeAmount;

  @HiveField(3)
  final double pendingAmount;

  PaymentSummaryModel({
    required this.payments,
    required this.paidAmount,
    required this.changeAmount,
    required this.pendingAmount,
  });

  factory PaymentSummaryModel.fromEntity(PaymentSummaryEntity entity) {
    return PaymentSummaryModel(
      payments: entity.payments.map((e) => PaymentModel.fromEntity(e)).toList(),
      paidAmount: entity.paidAmount,
      changeAmount: entity.changeAmount,
      pendingAmount: entity.pendingAmount,
    );
  }

  PaymentSummaryEntity toEntity() {
    return PaymentSummaryEntity(
      payments: payments.map((e) => e.toEntity()).toList(),
      paidAmount: paidAmount,
      changeAmount: changeAmount,
      pendingAmount: pendingAmount,
    );
  }

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      payments: (json['payments'] as List)
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      changeAmount: (json['changeAmount'] as num).toDouble(),
      pendingAmount: (json['pendingAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((e) => e.toJson()).toList(),
      'paidAmount': paidAmount,
      'changeAmount': changeAmount,
      'pendingAmount': pendingAmount,
    };
  }

  PaymentSummaryModel copyWith({
    List<PaymentModel>? payments,
    double? paidAmount,
    double? changeAmount,
    double? pendingAmount,
  }) {
    return PaymentSummaryModel(
      payments: payments ?? this.payments,
      paidAmount: paidAmount ?? this.paidAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
    );
  }
}
