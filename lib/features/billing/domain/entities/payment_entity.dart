import 'package:billing_system/core/enums/billing.dart';

class PaymentEntity {
  final String id;

  final PaymentMethod method;

  final double amount;

  final String? transactionId;

  final DateTime? paidAt;

  const PaymentEntity({
    required this.id,
    required this.method,
    required this.amount,
    this.transactionId,
    this.paidAt,
  });

  PaymentEntity copyWith({
    String? id,
    PaymentMethod? method,
    double? amount,
    String? transactionId,
    DateTime? paidAt,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
