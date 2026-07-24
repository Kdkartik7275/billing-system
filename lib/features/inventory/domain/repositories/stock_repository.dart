import '../entities/stock_batch_entity.dart';
import '../entities/stock_entity.dart';
import '../entities/stock_movement_entity.dart';

/// Contract for stock-quantity persistence and movement history.
/// Kept separate from [ProductRepository] since stock has a different
/// write frequency and lifecycle than catalog data.
abstract class StockRepository {
  Future<List<StockEntity>> getAllStock();

  Future<StockEntity?> getStockForProduct(
    String productId,
    String warehouseId,
  );

  Future<List<StockEntity>> getStockAcrossWarehouses(String productId);

  /// Applies a signed [quantityChange] to a product's stock and writes a
  /// corresponding [StockMovementEntity] atomically.
  Future<StockEntity> adjustStock({
    required String productId,
    required String warehouseId,
    required double quantityChange,
    required StockMovementType type,
    String? reason,
    String? referenceId,
    String? performedByUserId,
  });

  Future<List<StockMovementEntity>> getMovementHistory(String productId);

  Future<List<StockBatchEntity>> getBatchesForProduct(
    String productId,
    String warehouseId,
  );

  Future<StockBatchEntity> addBatch(StockBatchEntity batch);

  Stream<List<StockEntity>> watchStock();
}
