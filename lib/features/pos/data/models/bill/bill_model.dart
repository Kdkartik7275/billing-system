import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'bill_item_model.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 2)
class BillModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String receiptNumber;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String? customerName;

  @HiveField(4)
  final String? customerPhone;

  @HiveField(5)
  final List<BillItemModel> items;

  @HiveField(6)
  final double subtotal;

  @HiveField(7)
  final double taxRate;

  @HiveField(8)
  final double taxAmount;

  @HiveField(9)
  final double grandTotal;

  @HiveField(10)
  final String paymentMethod;

  @HiveField(11)
  final double amountTendered;

  @HiveField(12)
  final double changeGiven;

  @HiveField(13)
  final String status;

  @HiveField(14)
  final String? createdBy;

  @HiveField(15)
  final bool isOfflineCreated;

  BillModel({
    required this.id,
    required this.receiptNumber,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.amountTendered,
    required this.changeGiven,
    required this.status,
    this.createdBy,
    required this.isOfflineCreated,
  });

  // ── toEntity ───────────────────────────────────────────────────────

  BillEntity toEntity() => BillEntity(
    id: id,
    receiptNumber: receiptNumber,
    createdAt: createdAt,
    customerName: customerName,
    customerPhone: customerPhone,
    items: items.map((i) => i.toEntity()).toList(),
    subtotal: subtotal,
    taxRate: taxRate,
    taxAmount: taxAmount,
    grandTotal: grandTotal,
    paymentMethod: BillPaymentMethod.values.byName(paymentMethod),
    amountTendered: amountTendered,
    changeGiven: changeGiven,
    status: BillStatus.values.byName(status),
    createdBy: createdBy,
    isOfflineCreated: isOfflineCreated,
  );

  // ── fromEntity ─────────────────────────────────────────────────────

  factory BillModel.fromEntity(BillEntity entity) => BillModel(
    id: entity.id,
    receiptNumber: entity.receiptNumber,
    createdAt: entity.createdAt,
    customerName: entity.customerName,
    customerPhone: entity.customerPhone,
    items: entity.items.map((i) => BillItemModel.fromEntity(i)).toList(),
    subtotal: entity.subtotal,
    taxRate: entity.taxRate,
    taxAmount: entity.taxAmount,
    grandTotal: entity.grandTotal,
    paymentMethod: entity.paymentMethod.name,
    amountTendered: entity.amountTendered,
    changeGiven: entity.changeGiven,
    status: entity.status.name,
    createdBy: entity.createdBy,
    isOfflineCreated: entity.isOfflineCreated,
  );

  // ── toMap / fromMap (generic — used for local or non-Firestore) ────

  Map<String, dynamic> toMap() => {
    'id': id,
    'receiptNumber': receiptNumber,
    'createdAt': createdAt.toIso8601String(),
    'customerName': customerName,
    'customerPhone': customerPhone,
    'items': items.map((i) => i.toMap()).toList(),
    'subtotal': subtotal,
    'taxRate': taxRate,
    'taxAmount': taxAmount,
    'grandTotal': grandTotal,
    'paymentMethod': paymentMethod,
    'amountTendered': amountTendered,
    'changeGiven': changeGiven,
    'status': status,
    'createdBy': createdBy,
    'isOfflineCreated': isOfflineCreated,
  };

  factory BillModel.fromMap(Map<String, dynamic> map) => BillModel(
    id: map['id'] ?? '',
    receiptNumber: map['receiptNumber'] ?? '',
    createdAt: DateTime.parse(map['createdAt'] as String),
    customerName: map['customerName'] as String?,
    customerPhone: map['customerPhone'] as String?,
    items: (map['items'] as List<dynamic>? ?? [])
        .map((i) => BillItemModel.fromMap(i as Map<String, dynamic>))
        .toList(),
    subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
    taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.0,
    taxAmount: (map['taxAmount'] as num?)?.toDouble() ?? 0.0,
    grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: map['paymentMethod'] ?? 'cash',
    amountTendered: (map['amountTendered'] as num?)?.toDouble() ?? 0.0,
    changeGiven: (map['changeGiven'] as num?)?.toDouble() ?? 0.0,
    status: map['status'] ?? 'completed',
    createdBy: map['createdBy'] as String?,
    isOfflineCreated: map['isOfflineCreated'] as bool? ?? false,
  );

  // ── toFirestore ────────────────────────────────────────────────────

  Map<String, dynamic> toFirestore() => {
    'receiptNumber': receiptNumber,
    'createdAt': Timestamp.fromDate(createdAt),
    'customerName': customerName,
    'customerPhone': customerPhone,
    'items': items.map((i) => i.toMap()).toList(),
    'subtotal': subtotal,
    'taxRate': taxRate,
    'taxAmount': taxAmount,
    'grandTotal': grandTotal,
    'paymentMethod': paymentMethod,
    'amountTendered': amountTendered,
    'changeGiven': changeGiven,
    'status': status,
    'createdBy': createdBy,
    'isOfflineCreated': isOfflineCreated,
  };

  // ── fromFirestore ──────────────────────────────────────────────────

  factory BillModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return BillModel(
      id: doc.id,
      receiptNumber: map['receiptNumber'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      customerName: map['customerName'] as String?,
      customerPhone: map['customerPhone'] as String?,
      items: (map['items'] as List<dynamic>? ?? [])
          .map((i) => BillItemModel.fromMap(i as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (map['taxAmount'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? 'cash',
      amountTendered: (map['amountTendered'] as num?)?.toDouble() ?? 0.0,
      changeGiven: (map['changeGiven'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'completed',
      createdBy: map['createdBy'] as String?,
      isOfflineCreated: map['isOfflineCreated'] as bool? ?? false,
    );
  }

  BillModel copyWith({
    String? id,
    String? receiptNumber,
    DateTime? createdAt,
    String? customerName,
    String? customerPhone,
    List<BillItemModel>? items,
    double? subtotal,
    double? taxRate,
    double? taxAmount,
    double? grandTotal,
    String? paymentMethod,
    double? amountTendered,
    double? changeGiven,
    String? status,
    String? createdBy,
    bool? isOfflineCreated,
  }) {
    return BillModel(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountTendered: amountTendered ?? this.amountTendered,
      changeGiven: changeGiven ?? this.changeGiven,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      isOfflineCreated: isOfflineCreated ?? this.isOfflineCreated,
    );
  }
}
