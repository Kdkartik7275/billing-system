import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:billing_system/features/billing/domain/entities/customer_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_summary_entity.dart';

class BillEntity {
  final String id;
  final String billNumber;

  final String warehouseId;
  final String cashierId;

  final CustomerEntity? customer;

  final List<BillItemEntity> items;

  final double subTotal;
  final double discount;
  final double tax;
  final double grandTotal;

  final PaymentSummaryEntity payment;

  final BillStatus status;

  final bool synced;

  final DateTime createdAt;
  final DateTime updatedAt;

  const BillEntity({
    required this.id,
    required this.billNumber,
    required this.warehouseId,
    required this.cashierId,
    this.customer,
    required this.items,
    required this.subTotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.payment,
    required this.status,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  BillEntity copyWith({
    String? id,
    String? billNumber,
    String? warehouseId,
    String? cashierId,
    CustomerEntity? customer,
    List<BillItemEntity>? items,
    double? subTotal,
    double? discount,
    double? tax,
    double? grandTotal,
    PaymentSummaryEntity? payment,
    BillStatus? status,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillEntity(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      warehouseId: warehouseId ?? this.warehouseId,
      cashierId: cashierId ?? this.cashierId,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      grandTotal: grandTotal ?? this.grandTotal,
      payment: payment ?? this.payment,
      status: status ?? this.status,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
