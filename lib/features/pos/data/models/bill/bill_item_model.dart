import 'package:billing_system/features/pos/domain/entity/bill_item_entity.dart';
import 'package:hive/hive.dart';

part 'bill_item_model.g.dart';

@HiveType(typeId: 1)
class BillItemModel extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String sku;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final double totalPrice;

  BillItemModel({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  BillItemEntity toEntity() => BillItemEntity(
        productId: productId,
        productName: productName,
        sku: sku,
        unitPrice: unitPrice,
        quantity: quantity,
        totalPrice: totalPrice,
      );

  factory BillItemModel.fromEntity(BillItemEntity entity) => BillItemModel(
        productId: entity.productId,
        productName: entity.productName,
        sku: entity.sku,
        unitPrice: entity.unitPrice,
        quantity: entity.quantity,
        totalPrice: entity.totalPrice,
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'sku': sku,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'totalPrice': totalPrice,
      };

  factory BillItemModel.fromMap(Map<String, dynamic> map) => BillItemModel(
        productId: map['productId'] ?? '',
        productName: map['productName'] ?? '',
        sku: map['sku'] ?? '',
        unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
        quantity: (map['quantity'] as num?)?.toInt() ?? 0,
        totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      );
}