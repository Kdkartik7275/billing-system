import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: HiveTypeIds.purchaseModel)
class PurchaseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String supplierId;

  @HiveField(3)
  final String warehouseId;

  @HiveField(4)
  final String invoiceNumber;

  @HiveField(5)
  final DateTime purchaseDate;

  @HiveField(6)
  final DateTime billDate;

  @HiveField(7)
  final int quantity;

  @HiveField(8)
  final double price;

  @HiveField(9)
  final double discount;

  @HiveField(10)
  final double tax;

  @HiveField(11)
  final String paymentMethod;

  @HiveField(12)
  final DateTime dueDate;

  @HiveField(13)
  final String batchNumber;

  @HiveField(14)
  final String? notes;

  @HiveField(15)
  final double? paidAmount;

  PurchaseModel({
    required this.id,
    required this.productId,
    required this.supplierId,
    required this.warehouseId,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.billDate,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.tax,
    required this.paymentMethod,
    required this.dueDate,
    required this.batchNumber,
    this.notes,
    this.paidAmount,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      supplierId: json['supplierId'] as String,
      warehouseId: json['warehouseId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      billDate: DateTime.parse(json['billDate'] as String),
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      batchNumber: json['batchNumber'] as String,
      notes: json['notes'] as String?,
      paidAmount: json['paidAmount'] != null
          ? (json['paidAmount'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'supplierId': supplierId,
      'warehouseId': warehouseId,
      'invoiceNumber': invoiceNumber,
      'purchaseDate': purchaseDate.toIso8601String(),
      'billDate': billDate.toIso8601String(),
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'tax': tax,
      'paymentMethod': paymentMethod,
      'dueDate': dueDate.toIso8601String(),
      'batchNumber': batchNumber,
      'notes': notes,
      'paidAmount': paidAmount,
    };
  }

  factory PurchaseModel.fromEntity(PurchaseEntity entity) {
    return PurchaseModel(
      id: entity.id,
      productId: entity.productId,
      supplierId: entity.supplierId,
      warehouseId: entity.warehouseId,
      invoiceNumber: entity.invoiceNumber,
      purchaseDate: entity.purchaseDate,
      billDate: entity.billDate,
      quantity: entity.quantity,
      price: entity.price,
      discount: entity.discount,
      tax: entity.tax,
      paymentMethod: entity.paymentMethod,
      dueDate: entity.dueDate,
      batchNumber: entity.batchNumber,
      paidAmount: entity.paidAmount,
      notes: entity.notes,
    );
  }

  PurchaseEntity toEntity() {
    return PurchaseEntity(
      id: id,
      productId: productId,
      supplierId: supplierId,
      warehouseId: warehouseId,
      invoiceNumber: invoiceNumber,
      purchaseDate: purchaseDate,
      billDate: billDate,
      quantity: quantity,
      price: price,
      discount: discount,
      tax: tax,
      paymentMethod: paymentMethod,
      dueDate: dueDate,
      batchNumber: batchNumber,
      notes: notes,
      paidAmount: paidAmount,
    );
  }

  PurchaseModel copyWith({
    String? id,
    String? productId,
    String? supplierId,
    String? warehouseId,
    String? invoiceNumber,
    DateTime? purchaseDate,
    DateTime? billDate,
    int? quantity,
    double? price,
    double? discount,
    double? tax,
    String? paymentMethod,
    DateTime? dueDate,
    String? batchNumber,
    String? notes,
    double? paidAmount,
  }) {
    return PurchaseModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      warehouseId: warehouseId ?? this.warehouseId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      billDate: billDate ?? this.billDate,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      dueDate: dueDate ?? this.dueDate,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }

  double get subtotal => quantity * price;

  double get taxableAmount => subtotal - discount;

  double get totalAmount => taxableAmount + tax;

  @override
  String toString() {
    return 'PurchaseModel('
        'id: $id, '
        'invoiceNumber: $invoiceNumber, '
        'productId: $productId, '
        'supplierId: $supplierId'
        ')';
  }
}
