import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:billing_system/features/billing/data/models/customer_model.dart';
import 'package:billing_system/features/billing/data/models/payment_summary_model.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 27)
class BillModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String billNumber;

  @HiveField(3)
  final String warehouseId;

  @HiveField(4)
  final String cashierId;

  @HiveField(5)
  final CustomerModel? customer;

  @HiveField(6)
  final List<BillItemModel> items;

  @HiveField(7)
  final double subTotal;

  @HiveField(8)
  final double discount;

  @HiveField(9)
  final double tax;

  @HiveField(10)
  final double grandTotal;

  @HiveField(11)
  final PaymentSummaryModel payment;

  @HiveField(12)
  final BillStatus status;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  @HiveField(15)
  final bool synced;

  BillModel({
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
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory BillModel.fromEntity(BillEntity entity) {
    return BillModel(
      id: entity.id,
      billNumber: entity.billNumber,
      warehouseId: entity.warehouseId,
      cashierId: entity.cashierId,
      customer: entity.customer != null
          ? CustomerModel.fromEntity(entity.customer!)
          : null,
      items: entity.items.map((e) => BillItemModel.fromEntity(e)).toList(),
      subTotal: entity.subTotal,
      discount: entity.discount,
      tax: entity.tax,
      grandTotal: entity.grandTotal,
      payment: PaymentSummaryModel.fromEntity(entity.payment),
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      synced: entity.synced,
    );
  }

  BillEntity toEntity() {
    return BillEntity(
      id: id,
      billNumber: billNumber,
      warehouseId: warehouseId,
      cashierId: cashierId,
      customer: customer?.toEntity(),
      items: items.map((e) => e.toEntity()).toList(),
      subTotal: subTotal,
      discount: discount,
      tax: tax,
      grandTotal: grandTotal,
      payment: payment.toEntity(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      synced: synced,
    );
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String,
      billNumber: json['billNumber'] as String,
      warehouseId: json['warehouseId'] as String,
      cashierId: json['cashierId'] as String,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List)
          .map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      payment: PaymentSummaryModel.fromJson(
        json['payment'] as Map<String, dynamic>,
      ),
      status: BillStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      synced: json['synced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billNumber': billNumber,
      'warehouseId': warehouseId,
      'cashierId': cashierId,
      'customer': customer?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'subTotal': subTotal,
      'discount': discount,
      'tax': tax,
      'grandTotal': grandTotal,
      'payment': payment.toJson(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced,
    };
  }

  BillModel copyWith({
    String? id,
    String? billNumber,
    String? warehouseId,
    String? cashierId,
    CustomerModel? customer,
    List<BillItemModel>? items,
    double? subTotal,
    double? discount,
    double? tax,
    double? grandTotal,
    PaymentSummaryModel? payment,
    BillStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return BillModel(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }
}
