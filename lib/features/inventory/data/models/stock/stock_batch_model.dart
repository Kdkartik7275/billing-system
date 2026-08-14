import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'stock_batch_model.g.dart';

@HiveType(typeId: HiveTypeIds.stockBatchModel)
class StockBatchModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String warehouseId;

  @HiveField(3)
  final String batchNumber;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final DateTime? manufactureDate;

  @HiveField(6)
  final DateTime? expiryDate;

  @HiveField(7)
  final double purchasePrice;

  @HiveField(8)
  final DateTime receivedAt;

  StockBatchModel({
    required this.id,
    required this.productId,
    required this.warehouseId,
    required this.batchNumber,
    required this.quantity,
    this.manufactureDate,
    this.expiryDate,
    required this.purchasePrice,
    required this.receivedAt,
  });

  factory StockBatchModel.fromEntity(StockBatchEntity entity) {
    return StockBatchModel(
      id: entity.id,
      productId: entity.productId,
      warehouseId: entity.warehouseId,
      batchNumber: entity.batchNumber,
      quantity: entity.quantity,
      manufactureDate: entity.manufactureDate,
      expiryDate: entity.expiryDate,
      purchasePrice: entity.purchasePrice,
      receivedAt: entity.receivedAt,
    );
  }

  StockBatchEntity toEntity() {
    return StockBatchEntity(
      id: id,
      productId: productId,
      warehouseId: warehouseId,
      batchNumber: batchNumber,
      quantity: quantity,
      manufactureDate: manufactureDate,
      expiryDate: expiryDate,
      purchasePrice: purchasePrice,
      receivedAt: receivedAt,
    );
  }

  factory StockBatchModel.fromJson(Map<String, dynamic> json) {
    return StockBatchModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      warehouseId: json['warehouseId'] as String,
      batchNumber: json['batchNumber'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      manufactureDate: json['manufactureDate'] != null
          ? DateTime.parse(json['manufactureDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      receivedAt: DateTime.parse(json['receivedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'warehouseId': warehouseId,
      'batchNumber': batchNumber,
      'quantity': quantity,
      'manufactureDate': manufactureDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'purchasePrice': purchasePrice,
      'receivedAt': receivedAt.toIso8601String(),
    };
  }

  StockBatchModel copyWith({
    String? id,
    String? productId,
    String? warehouseId,
    String? batchNumber,
    double? quantity,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    double? purchasePrice,
    DateTime? receivedAt,
  }) {
    return StockBatchModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      batchNumber: batchNumber ?? this.batchNumber,
      quantity: quantity ?? this.quantity,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }
}
