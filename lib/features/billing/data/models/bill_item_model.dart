import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bill_item_model.g.dart';

@HiveType(typeId: HiveTypeIds.billItemModel)
class BillItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final String sku;

  @HiveField(4)
  final String barcode;

  @HiveField(5)
  final String? variantId;

  @HiveField(6)
  final String? batchId;

  @HiveField(7)
  final double quantity;

  @HiveField(8)
  final double unitPrice;

  @HiveField(9)
  final double mrp;

  @HiveField(10)
  final double discount;

  @HiveField(11)
  final double taxPercent;

  @HiveField(12)
  final double tax;

  @HiveField(13)
  final double total;

  BillItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.barcode,
    this.variantId,
    this.batchId,
    required this.quantity,
    required this.unitPrice,
    required this.mrp,
    required this.discount,
    required this.taxPercent,
    required this.tax,
    required this.total,
  });

  factory BillItemModel.fromEntity(BillItemEntity entity) {
    return BillItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      sku: entity.sku,
      barcode: entity.barcode,
      variantId: entity.variantId,
      batchId: entity.batchId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      mrp: entity.mrp,
      discount: entity.discount,
      taxPercent: entity.taxPercent,
      tax: entity.tax,
      total: entity.total,
    );
  }

  BillItemEntity toEntity() {
    return BillItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      sku: sku,
      barcode: barcode,
      variantId: variantId,
      batchId: batchId,
      quantity: quantity,
      unitPrice: unitPrice,
      mrp: mrp,
      discount: discount,
      taxPercent: taxPercent,
      tax: tax,
      total: total,
    );
  }

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String,
      barcode: json['barcode'] as String,
      variantId: json['variantId'] as String?,
      batchId: json['batchId'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      taxPercent: (json['taxPercent'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'barcode': barcode,
      'variantId': variantId,
      'batchId': batchId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'mrp': mrp,
      'discount': discount,
      'taxPercent': taxPercent,
      'tax': tax,
      'total': total,
    };
  }

  BillItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? sku,
    String? barcode,
    String? variantId,
    String? batchId,
    double? quantity,
    double? unitPrice,
    double? mrp,
    double? discount,
    double? taxPercent,
    double? tax,
    double? total,
  }) {
    return BillItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      variantId: variantId ?? this.variantId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      mrp: mrp ?? this.mrp,
      discount: discount ?? this.discount,
      taxPercent: taxPercent ?? this.taxPercent,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }
}
