import 'package:billing_system/features/reports/domain/entities/cash_reconciliation_entity.dart';
import 'package:billing_system/features/reports/domain/entities/sales_summary_entity.dart';
import 'package:billing_system/features/reports/domain/entities/tender_breakdown_entity.dart';

enum ReportStatus { open, closed }

class ReportEntity {
  final String id;
  final String shopId;
  final DateTime businessDate;

  final ReportStatus status;
  final DateTime? closedAt;
  final String? closedBy;

  final CashReconciliationEntity cashReconciliation;
  final TenderBreakdownEntity tenderBreakdown;
  final SalesSummaryEntity salesSummary;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ReportEntity({
    required this.id,
    required this.shopId,
    required this.businessDate,
    this.status = ReportStatus.open,
    this.closedAt,
    this.closedBy,
    required this.cashReconciliation,
    required this.tenderBreakdown,
    required this.salesSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  ReportEntity copyWith({
    String? id,
    String? shopId,
    DateTime? businessDate,
    ReportStatus? status,
    DateTime? closedAt,
    String? closedBy,
    CashReconciliationEntity? cashReconciliation,
    TenderBreakdownEntity? tenderBreakdown,
    SalesSummaryEntity? salesSummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      businessDate: businessDate ?? this.businessDate,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      cashReconciliation: cashReconciliation ?? this.cashReconciliation,
      tenderBreakdown: tenderBreakdown ?? this.tenderBreakdown,
      salesSummary: salesSummary ?? this.salesSummary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
