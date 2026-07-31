import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'stock_model.g.dart';

@HiveType(typeId: 14)
class StockModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String warehouseId;

  @HiveField(3)
  final String? variantId;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final double reservedQuantity;

  @HiveField(6)
  final DateTime lastUpdated;

  StockModel({
    required this.id,
    required this.productId,
    required this.warehouseId,
    this.variantId,
    required this.quantity,
    this.reservedQuantity = 0,
    required this.lastUpdated,
  });

  factory StockModel.fromEntity(StockEntity entity) {
    return StockModel(
      id: entity.id,
      productId: entity.productId,
      warehouseId: entity.warehouseId,
      variantId: entity.variantId,
      quantity: entity.quantity,
      reservedQuantity: entity.reservedQuantity,
      lastUpdated: entity.lastUpdated,
    );
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      productId: productId,
      warehouseId: warehouseId,
      variantId: variantId,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
      lastUpdated: lastUpdated,
    );
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      warehouseId: json['warehouseId'] ?? '',
      variantId: json['variantId'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      reservedQuantity: (json['reservedQuantity'] ?? 0).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'warehouseId': warehouseId,
      'variantId': variantId,
      'quantity': quantity,
      'reservedQuantity': reservedQuantity,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  StockModel copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? variantId,
    double? quantity,
    double? reservedQuantity,
    DateTime? lastUpdated,
  }) {
    return StockModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
