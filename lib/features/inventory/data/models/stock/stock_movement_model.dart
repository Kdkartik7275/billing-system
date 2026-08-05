import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'stock_movement_model.g.dart';

@HiveType(typeId: 16)
enum StockMovementTypeModel {
  @HiveField(0)
  purchaseIn,

  @HiveField(1)
  saleOut,

  @HiveField(2)
  transferIn,

  @HiveField(3)
  transferOut,

  @HiveField(4)
  adjustment,

  @HiveField(5)
  returnIn,

  @HiveField(6)
  returnOut,

  @HiveField(7)
  damaged,

  @HiveField(8)
  expired,
}

@HiveType(typeId: 17)
class StockMovementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String warehouseId;

  @HiveField(3)
  final String? variantId;

  @HiveField(4)
  final String? batchId;

  @HiveField(5)
  final StockMovementTypeModel type;

  @HiveField(6)
  final double quantityChange;

  @HiveField(7)
  final double resultingQuantity;

  @HiveField(8)
  final String? reason;

  @HiveField(9)
  final String? referenceId;

  @HiveField(10)
  final String? performedByUserId;

  @HiveField(11)
  final DateTime createdAt;

  StockMovementModel({
    required this.id,
    required this.productId,
    required this.warehouseId,
    this.variantId,
    this.batchId,
    required this.type,
    required this.quantityChange,
    required this.resultingQuantity,
    this.reason,
    this.referenceId,
    this.performedByUserId,
    required this.createdAt,
  });

  factory StockMovementModel.fromEntity(StockMovementEntity entity) {
    return StockMovementModel(
      id: entity.id,
      productId: entity.productId,
      warehouseId: entity.warehouseId,
      variantId: entity.variantId,
      batchId: entity.batchId,
      type: StockMovementTypeModel.values.byName(entity.type.name),
      quantityChange: entity.quantityChange,
      resultingQuantity: entity.resultingQuantity,
      reason: entity.reason,
      referenceId: entity.referenceId,
      performedByUserId: entity.performedByUserId,
      createdAt: entity.createdAt,
    );
  }

  StockMovementEntity toEntity() {
    return StockMovementEntity(
      id: id,
      productId: productId,
      warehouseId: warehouseId,
      variantId: variantId,
      batchId: batchId,
      type: StockMovementType.values.byName(type.name),
      quantityChange: quantityChange,
      resultingQuantity: resultingQuantity,
      reason: reason,
      referenceId: referenceId,
      performedByUserId: performedByUserId,
      createdAt: createdAt,
    );
  }

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      warehouseId: json['warehouseId'] as String,
      variantId: json['variantId'] as String?,
      batchId: json['batchId'] as String?,
      type: StockMovementTypeModel.values.byName(json['type'] as String),
      quantityChange: (json['quantityChange'] as num).toDouble(),
      resultingQuantity: (json['resultingQuantity'] as num).toDouble(),
      reason: json['reason'] as String?,
      referenceId: json['referenceId'] as String?,
      performedByUserId: json['performedByUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'warehouseId': warehouseId,
      'variantId': variantId,
      'batchId': batchId,
      'type': type.name,
      'quantityChange': quantityChange,
      'resultingQuantity': resultingQuantity,
      'reason': reason,
      'referenceId': referenceId,
      'performedByUserId': performedByUserId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  StockMovementModel copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? variantId,
    String? batchId,
    StockMovementTypeModel? type,
    double? quantityChange,
    double? resultingQuantity,
    String? reason,
    String? referenceId,
    String? performedByUserId,
    DateTime? createdAt,
  }) {
    return StockMovementModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      variantId: variantId ?? this.variantId,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      quantityChange: quantityChange ?? this.quantityChange,
      resultingQuantity: resultingQuantity ?? this.resultingQuantity,
      reason: reason ?? this.reason,
      referenceId: referenceId ?? this.referenceId,
      performedByUserId: performedByUserId ?? this.performedByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
