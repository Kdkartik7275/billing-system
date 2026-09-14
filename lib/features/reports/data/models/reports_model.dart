
import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/reports/data/models/cash_reconciliation_model.dart';
import 'package:billing_system/features/reports/data/models/sales_summary_model.dart';
import 'package:billing_system/features/reports/data/models/tender_breakdown_model.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'reports_model.g.dart';

@HiveType(typeId: HiveTypeIds.reportModel)
class ReportModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String shopId;

  @HiveField(2)
  final DateTime businessDate;

  /// Stored as String so we don't need a separate Hive
  /// adapter/typeId for ReportStatus.
  @HiveField(3)
  final String status;

  @HiveField(4)
  final DateTime? closedAt;

  @HiveField(5)
  final String? closedBy;

  @HiveField(6)
  final CashReconciliationModel cashReconciliation;

  @HiveField(7)
  final TenderBreakdownModel tenderBreakdown;

  @HiveField(8)
  final SalesSummaryModel salesSummary;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const ReportModel({
    required this.id,
    required this.shopId,
    required this.businessDate,
    this.status = 'open',
    this.closedAt,
    this.closedBy,
    required this.cashReconciliation,
    required this.tenderBreakdown,
    required this.salesSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportModel.fromEntity(
    ReportEntity entity,
  ) {
    return ReportModel(
      id: entity.id,
      shopId: entity.shopId,
      businessDate: entity.businessDate,
      status: entity.status.name,
      closedAt: entity.closedAt,
      closedBy: entity.closedBy,
      cashReconciliation:
          CashReconciliationModel.fromEntity(
        entity.cashReconciliation,
      ),
      tenderBreakdown:
          TenderBreakdownModel.fromEntity(
        entity.tenderBreakdown,
      ),
      salesSummary:
          SalesSummaryModel.fromEntity(
        entity.salesSummary,
      ),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      shopId: shopId,
      businessDate: businessDate,
      status: ReportStatus.values.byName(status),
      closedAt: closedAt,
      closedBy: closedBy,
      cashReconciliation:
          cashReconciliation.toEntity(),
      tenderBreakdown:
          tenderBreakdown.toEntity(),
      salesSummary:
          salesSummary.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ReportModel copyWith({
    String? id,
    String? shopId,
    DateTime? businessDate,
    String? status,
    DateTime? closedAt,
    String? closedBy,
    CashReconciliationModel? cashReconciliation,
    TenderBreakdownModel? tenderBreakdown,
    SalesSummaryModel? salesSummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      businessDate:
          businessDate ?? this.businessDate,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      cashReconciliation:
          cashReconciliation ??
              this.cashReconciliation,
      tenderBreakdown:
          tenderBreakdown ??
              this.tenderBreakdown,
      salesSummary:
          salesSummary ??
              this.salesSummary,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'businessDate':
          businessDate.toIso8601String(),
      'status': status,
      'closedAt':
          closedAt?.toIso8601String(),
      'closedBy': closedBy,
      'cashReconciliation':
          cashReconciliation.toJson(),
      'tenderBreakdown':
          tenderBreakdown.toJson(),
      'salesSummary':
          salesSummary.toJson(),
      'createdAt':
          createdAt.toIso8601String(),
      'updatedAt':
          updatedAt.toIso8601String(),
    };
  }

  factory ReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReportModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      businessDate: DateTime.parse(
        json['businessDate'] as String,
      ),
      status:
          json['status'] as String? ?? 'open',
      closedAt:
          json['closedAt'] != null
              ? DateTime.parse(
                  json['closedAt'] as String,
                )
              : null,
      closedBy:
          json['closedBy'] as String?,
      cashReconciliation:
          CashReconciliationModel.fromJson(
        Map<String, dynamic>.from(
          json['cashReconciliation'] as Map,
        ),
      ),
      tenderBreakdown:
          TenderBreakdownModel.fromJson(
        Map<String, dynamic>.from(
          json['tenderBreakdown'] as Map,
        ),
      ),
      salesSummary:
          SalesSummaryModel.fromJson(
        Map<String, dynamic>.from(
          json['salesSummary'] as Map,
        ),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
    );
  }
}