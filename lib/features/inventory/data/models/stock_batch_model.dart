import 'package:hive/hive.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';

part 'stock_batch_model.g.dart';

@HiveType(typeId: 5)
class StockBatchModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final int quantityRemaining;

  @HiveField(3)
  final double purchasePrice;

  @HiveField(4)
  final double sellingPrice;

  @HiveField(5)
  final DateTime receivedDate;

  StockBatchModel({
    required this.id,
    required this.productId,
    required this.quantityRemaining,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.receivedDate,
  });

  StockBatch toEntity() {
    return StockBatch(
      id: id,
      productId: productId,
      quantityRemaining: quantityRemaining,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      receivedDate: receivedDate,
    );
  }

  factory StockBatchModel.fromEntity(StockBatch entity) {
    return StockBatchModel(
      id: entity.id,
      productId: entity.productId,
      quantityRemaining: entity.quantityRemaining,
      purchasePrice: entity.purchasePrice,
      sellingPrice: entity.sellingPrice,
      receivedDate: entity.receivedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'quantityRemaining': quantityRemaining,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'receivedDate': receivedDate.toIso8601String(),
    };
  }

  factory StockBatchModel.fromMap(Map<String, dynamic> map) {
    return StockBatchModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      quantityRemaining: (map['quantityRemaining'] as num?)?.toInt() ?? 0,
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      receivedDate: map['receivedDate'] != null
          ? DateTime.parse(map['receivedDate'])
          : DateTime.now(),
    );
  }

  StockBatchModel copyWith({
    String? id,
    String? productId,
    int? quantityRemaining,
    double? purchasePrice,
    double? sellingPrice,
    DateTime? receivedDate,
  }) {
    return StockBatchModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      receivedDate: receivedDate ?? this.receivedDate,
    );
  }
}
