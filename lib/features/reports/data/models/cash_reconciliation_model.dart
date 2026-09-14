import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/reports/domain/entities/cash_reconciliation_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cash_reconciliation_model.g.dart';

@HiveType(typeId: HiveTypeIds.cashReconciliationModel)
class CashReconciliationModel {
  @HiveField(0)
  final double openingCashFloat;

  @HiveField(1)
  final double cashSales;

  @HiveField(2)
  final double cashRefunds;

  @HiveField(3)
  final double payouts;

  @HiveField(4)
  final double expectedCash;

  @HiveField(5)
  final double? countedCash;

  @HiveField(6)
  final double? variance;

  const CashReconciliationModel({
    this.openingCashFloat = 0,
    this.cashSales = 0,
    this.cashRefunds = 0,
    this.payouts = 0,
    this.expectedCash = 0,
    this.countedCash,
    this.variance,
  });

  factory CashReconciliationModel.fromEntity(CashReconciliationEntity entity) {
    return CashReconciliationModel(
      openingCashFloat: entity.openingCashFloat,
      cashSales: entity.cashSales,
      cashRefunds: entity.cashRefunds,
      payouts: entity.payouts,
      expectedCash: entity.expectedCash,
      countedCash: entity.countedCash,
      variance: entity.variance,
    );
  }

  CashReconciliationEntity toEntity() {
    return CashReconciliationEntity(
      openingCashFloat: openingCashFloat,
      cashSales: cashSales,
      cashRefunds: cashRefunds,
      payouts: payouts,
      expectedCash: expectedCash,
      countedCash: countedCash,
      variance: variance,
    );
  }

  CashReconciliationModel copyWith({
    double? openingCashFloat,
    double? cashSales,
    double? cashRefunds,
    double? payouts,
    double? expectedCash,
    double? countedCash,
    double? variance,
  }) {
    return CashReconciliationModel(
      openingCashFloat: openingCashFloat ?? this.openingCashFloat,
      cashSales: cashSales ?? this.cashSales,
      cashRefunds: cashRefunds ?? this.cashRefunds,
      payouts: payouts ?? this.payouts,
      expectedCash: expectedCash ?? this.expectedCash,
      countedCash: countedCash ?? this.countedCash,
      variance: variance ?? this.variance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openingCashFloat': openingCashFloat,
      'cashSales': cashSales,
      'cashRefunds': cashRefunds,
      'payouts': payouts,
      'expectedCash': expectedCash,
      'countedCash': countedCash,
      'variance': variance,
    };
  }

  factory CashReconciliationModel.fromJson(Map<String, dynamic> json) {
    return CashReconciliationModel(
      openingCashFloat: (json['openingCashFloat'] as num?)?.toDouble() ?? 0,
      cashSales: (json['cashSales'] as num?)?.toDouble() ?? 0,
      cashRefunds: (json['cashRefunds'] as num?)?.toDouble() ?? 0,
      payouts: (json['payouts'] as num?)?.toDouble() ?? 0,
      expectedCash: (json['expectedCash'] as num?)?.toDouble() ?? 0,
      countedCash: (json['countedCash'] as num?)?.toDouble(),
      variance: (json['variance'] as num?)?.toDouble(),
    );
  }
}
