import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/reports/domain/entities/tender_breakdown_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'tender_breakdown_model.g.dart';

@HiveType(typeId: HiveTypeIds.tenderBreakdownModel)
class TenderBreakdownModel {
  @HiveField(0)
  final double cash;

  @HiveField(1)
  final double upi;

  @HiveField(2)
  final double card;

  @HiveField(3)
  final double wallet;

  @HiveField(4)
  final double other;

  const TenderBreakdownModel({
    this.cash = 0,
    this.upi = 0,
    this.card = 0,
    this.wallet = 0,
    this.other = 0,
  });

  double get total =>
      cash +
      upi +
      card +
      wallet +
      other;

  factory TenderBreakdownModel.fromEntity(
    TenderBreakdownEntity entity,
  ) {
    return TenderBreakdownModel(
      cash: entity.cash,
      upi: entity.upi,
      card: entity.card,
      wallet: entity.wallet,
      other: entity.other,
    );
  }

  TenderBreakdownEntity toEntity() {
    return TenderBreakdownEntity(
      cash: cash,
      upi: upi,
      card: card,
      wallet: wallet,
      other: other,
    );
  }

  TenderBreakdownModel copyWith({
    double? cash,
    double? upi,
    double? card,
    double? wallet,
    double? other,
  }) {
    return TenderBreakdownModel(
      cash: cash ?? this.cash,
      upi: upi ?? this.upi,
      card: card ?? this.card,
      wallet: wallet ?? this.wallet,
      other: other ?? this.other,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'upi': upi,
      'card': card,
      'wallet': wallet,
      'other': other,
    };
  }

  factory TenderBreakdownModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TenderBreakdownModel(
      cash: (json['cash'] as num?)?.toDouble() ?? 0,
      upi: (json['upi'] as num?)?.toDouble() ?? 0,
      card: (json['card'] as num?)?.toDouble() ?? 0,
      wallet: (json['wallet'] as num?)?.toDouble() ?? 0,
      other: (json['other'] as num?)?.toDouble() ?? 0,
    );
  }
}