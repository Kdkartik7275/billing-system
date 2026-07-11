import 'package:hive/hive.dart';

part 'stock_transactions_entity.g.dart';

@HiveType(typeId: 3)
enum StockTransactionType {
  @HiveField(0)
  initialStock,

  @HiveField(1)
  purchase,

  @HiveField(2)
  sale,

  @HiveField(3)
  returnStock,

  @HiveField(4)
  damage,

  @HiveField(5)
  adjustment,
}

class StockTransaction {
  final String id;
  final String productId;
  final StockTransactionType type;
  final int previousStock;
  final int quantityChanged;
  final int newStock;
  final String? referenceId;
  final String? notes;
  final DateTime createdAt;

  const StockTransaction({
    required this.id,
    required this.productId,
    required this.type,
    required this.previousStock,
    required this.quantityChanged,
    required this.newStock,
    this.referenceId,
    this.notes,
    required this.createdAt,
  });

  StockTransaction copyWith({
    String? id,
    String? productId,
    StockTransactionType? type,
    int? previousStock,
    int? quantityChanged,
    int? newStock,
    String? referenceId,
    String? notes,
    DateTime? createdAt,
  }) {
    return StockTransaction(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      previousStock: previousStock ?? this.previousStock,
      quantityChanged: quantityChanged ?? this.quantityChanged,
      newStock: newStock ?? this.newStock,
      referenceId: referenceId ?? this.referenceId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
