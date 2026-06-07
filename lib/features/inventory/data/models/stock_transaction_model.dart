import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:hive/hive.dart';

part 'stock_transaction_model.g.dart';

@HiveType(typeId: 4)
class StockTransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final StockTransactionType type;

  @HiveField(3)
  final int previousStock;

  @HiveField(4)
  final int quantityChanged;

  @HiveField(5)
  final int newStock;

  @HiveField(6)
  final double? purchasePrice;

  @HiveField(7)
  final String? referenceId;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final DateTime createdAt;

  StockTransactionModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.previousStock,
    required this.quantityChanged,
    required this.newStock,
    this.purchasePrice,
    this.referenceId,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'type': type.name,
      'previousStock': previousStock,
      'quantityChanged': quantityChanged,
      'newStock': newStock,
      'purchasePrice': purchasePrice,
      'referenceId': referenceId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StockTransactionModel.fromMap(Map<String, dynamic> map) {
    return StockTransactionModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      type: StockTransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => StockTransactionType.adjustment,
      ),
      previousStock: (map['previousStock'] as num?)?.toInt() ?? 0,
      quantityChanged: (map['quantityChanged'] as num?)?.toInt() ?? 0,
      newStock: (map['newStock'] as num?)?.toInt() ?? 0,
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble(),
      referenceId: map['referenceId'],
      notes: map['notes'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  StockTransactionModel copyWith({
    String? id,
    String? productId,
    StockTransactionType? type,
    int? previousStock,
    int? quantityChanged,
    int? newStock,
    double? purchasePrice,
    String? referenceId,
    String? notes,
    DateTime? createdAt,
  }) {
    return StockTransactionModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      previousStock: previousStock ?? this.previousStock,
      quantityChanged: quantityChanged ?? this.quantityChanged,
      newStock: newStock ?? this.newStock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      referenceId: referenceId ?? this.referenceId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  StockTransaction toEntity() {
    return StockTransaction(
      id: id,
      productId: productId,
      type: type,
      previousStock: previousStock,
      quantityChanged: quantityChanged,
      newStock: newStock,
      purchasePrice: purchasePrice,
      referenceId: referenceId,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
