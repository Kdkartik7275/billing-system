import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/reports/domain/entities/sales_summary_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'sales_summary_model.g.dart';

@HiveType(typeId: HiveTypeIds.salesSummaryModel)
class SalesSummaryModel {
  @HiveField(0)
  final double totalSales;

  @HiveField(1)
  final int totalBills;

  @HiveField(2)
  final double voidAmount;

  @HiveField(3)
  final int voidCount;

  @HiveField(4)
  final double discountsGiven;

  @HiveField(5)
  final int discountedBillCount;

  @HiveField(6)
  final double refunds;

  @HiveField(7)
  final int refundCount;

  @HiveField(8)
  final double taxAmount;

  const SalesSummaryModel({
    this.totalSales = 0,
    this.totalBills = 0,
    this.voidAmount = 0,
    this.voidCount = 0,
    this.discountsGiven = 0,
    this.discountedBillCount = 0,
    this.refunds = 0,
    this.refundCount = 0,
    this.taxAmount = 0,
  });

  factory SalesSummaryModel.fromEntity(
    SalesSummaryEntity entity,
  ) {
    return SalesSummaryModel(
      totalSales: entity.totalSales,
      totalBills: entity.totalBills,
      voidAmount: entity.voidAmount,
      voidCount: entity.voidCount,
      discountsGiven: entity.discountsGiven,
      discountedBillCount: entity.discountedBillCount,
      refunds: entity.refunds,
      refundCount: entity.refundCount,
      taxAmount: entity.taxAmount,
    );
  }

  SalesSummaryEntity toEntity() {
    return SalesSummaryEntity(
      totalSales: totalSales,
      totalBills: totalBills,
      voidAmount: voidAmount,
      voidCount: voidCount,
      discountsGiven: discountsGiven,
      discountedBillCount: discountedBillCount,
      refunds: refunds,
      refundCount: refundCount,
      taxAmount: taxAmount,
    );
  }

  SalesSummaryModel copyWith({
    double? totalSales,
    int? totalBills,
    double? voidAmount,
    int? voidCount,
    double? discountsGiven,
    int? discountedBillCount,
    double? refunds,
    int? refundCount,
    double? taxAmount,
  }) {
    return SalesSummaryModel(
      totalSales: totalSales ?? this.totalSales,
      totalBills: totalBills ?? this.totalBills,
      voidAmount: voidAmount ?? this.voidAmount,
      voidCount: voidCount ?? this.voidCount,
      discountsGiven:
          discountsGiven ?? this.discountsGiven,
      discountedBillCount:
          discountedBillCount ?? this.discountedBillCount,
      refunds: refunds ?? this.refunds,
      refundCount: refundCount ?? this.refundCount,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalBills': totalBills,
      'voidAmount': voidAmount,
      'voidCount': voidCount,
      'discountsGiven': discountsGiven,
      'discountedBillCount': discountedBillCount,
      'refunds': refunds,
      'refundCount': refundCount,
      'taxAmount': taxAmount,
    };
  }

  factory SalesSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesSummaryModel(
      totalSales:
          (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalBills:
          (json['totalBills'] as num?)?.toInt() ?? 0,
      voidAmount:
          (json['voidAmount'] as num?)?.toDouble() ?? 0,
      voidCount:
          (json['voidCount'] as num?)?.toInt() ?? 0,
      discountsGiven:
          (json['discountsGiven'] as num?)?.toDouble() ?? 0,
      discountedBillCount:
          (json['discountedBillCount'] as num?)?.toInt() ?? 0,
      refunds:
          (json['refunds'] as num?)?.toDouble() ?? 0,
      refundCount:
          (json['refundCount'] as num?)?.toInt() ?? 0,
      taxAmount:
          (json['taxAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}