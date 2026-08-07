import 'package:billing_system/features/billing/domain/entities/payment_entity.dart';

class PaymentSummaryEntity {
  final List<PaymentEntity> payments;

  final double paidAmount;
  final double changeAmount;
  final double pendingAmount;

  const PaymentSummaryEntity({
    required this.payments,
    required this.paidAmount,
    required this.changeAmount,
    required this.pendingAmount,
  });

  PaymentSummaryEntity copyWith({
    List<PaymentEntity>? payments,
    double? paidAmount,
    double? changeAmount,
    double? pendingAmount,
  }) {
    return PaymentSummaryEntity(
      payments: payments ?? this.payments,
      paidAmount: paidAmount ?? this.paidAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
    );
  }
}
