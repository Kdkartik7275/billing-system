import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import '../entities/stock_entity.dart';

abstract class StockRepository {
  // ------------- Stock Entity --------------
  ResultFuture<List<StockEntity>> getAllStock();

  ResultFuture<StockEntity?> getStockForProduct(String productId);

  ResultFuture<StockEntity> createInitialStock(StockEntity stock);

  // ------------- Stock Movement --------------
  ResultFuture<List<StockMovementEntity>> getAllStockMovements();
  ResultFuture<List<StockMovementEntity>> getStockMovementsForProduct(
    String productId,
  );
  ResultFuture<StockMovementEntity> createStockMovement(
    StockMovementEntity movement,
  );

  // ------------- Stock Batch --------------
  ResultFuture<List<StockBatchEntity>> getAllStockBatches();
  ResultFuture<List<StockBatchEntity>> getStockBatchesForProduct(
    String productId,
  );
  ResultFuture<StockBatchEntity> createStockBatch(StockBatchEntity batch);
  ResultFuture<StockEntity> updateStock(StockEntity stock);

  // -------------- Purchase Stock --------------
  ResultFuture<void> purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
    required DateTime purchaseDate,
    required String invoiceNumber,
    required DateTime billDate,
    required String batchNumber,
    DateTime? expiryDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    required DateTime dueDate,
    String? notes,
  });

  // -------------- Sell Stock --------------
  ResultFuture<void> sellStock({
    required String productId,
    required String warehouseId,
    required int quantity,
    required double price,
    required DateTime saleDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    String? reason,
    String? referenceId,
    String? notes,
  });
}
