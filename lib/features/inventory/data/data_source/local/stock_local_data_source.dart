import 'package:billing_system/features/inventory/data/models/stock/purchase_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class StockLocalDataSource {
  // ---------- Stock ----------

  Future<List<StockModel>> getAllStock();

  Future<StockModel?> getStockForProduct(String productId);

  Future<StockModel> createInitialStock(StockModel stock);

  // ---------- Stock Movement ----------

  Future<List<StockMovementModel>> getAllStockMovements();

  Future<List<StockMovementModel>> getStockMovementsForProduct(
    String productId,
  );

  Future<StockMovementModel> createStockMovement(StockMovementModel movement);

  // ---------- Stock Batch ----------

  Future<List<StockBatchModel>> getAllStockBatches();

  Future<List<StockBatchModel>> getStockBatchesForProduct(String productId);

  Future<StockBatchModel> createStockBatch(StockBatchModel batch);
  Future<StockBatchModel> updateStockBatch(StockBatchModel batch);

  Future<StockModel> updateStock(StockModel stock);

  Future<void> clear();

  Future<void> replaceStockMovementsForProduct(
    String productId,
    List<StockMovementModel> movements,
  );

  Future<void> replaceStockBatchesForProduct(
    String productId,
    List<StockBatchModel> batches,
  );

  Future<void> clearStockMovements();

  Future<void> clearStockBatches();

  // ---------------- DAILY FETCH GATE ----------------
  Future<DateTime?> getLastFetchedAt(String key);
  Future<void> setLastFetchedAt(String key, DateTime time);

  // ---------- Purchase ----------

  Future<List<PurchaseModel>> getAllPurchases();

  Future<List<PurchaseModel>> getPurchasesForProduct(String productId);

  Future<PurchaseModel> createPurchase(PurchaseModel purchase);

  Future<void> replacePurchasesForProduct(
    String productId,
    List<PurchaseModel> purchases,
  );

  Future<void> clearPurchases();
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  final Box<StockModel> stockBox;
  final Box<StockMovementModel> movementBox;
  final Box<StockBatchModel> batchBox;
  final Box<PurchaseModel> purchaseBox;

  final Box metaBox;

  const StockLocalDataSourceImpl({
    required this.stockBox,
    required this.movementBox,
    required this.batchBox,
    required this.purchaseBox,

    required this.metaBox,
  });

  // ======================================================
  // Stock
  // ======================================================

  @override
  Future<StockModel> createInitialStock(StockModel stock) async {
    await stockBox.put(stock.id, stock);
    return stock;
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    return stockBox.values.toList();
  }

  @override
  Future<StockModel?> getStockForProduct(String productId) async {
    try {
      return stockBox.values.firstWhere(
        (stock) => stock.productId == productId,
      );
    } catch (_) {
      return null;
    }
  }

  // ======================================================
  // Stock Movements
  // ======================================================

  @override
  Future<StockMovementModel> createStockMovement(
    StockMovementModel movement,
  ) async {
    await movementBox.put(movement.id, movement);
    return movement;
  }

  @override
  Future<List<StockMovementModel>> getAllStockMovements() async {
    return movementBox.values.toList();
  }

  @override
  Future<List<StockMovementModel>> getStockMovementsForProduct(
    String productId,
  ) async {
    return movementBox.values.where((e) => e.productId == productId).toList();
  }

  // ======================================================
  // Stock Batches
  // ======================================================

  @override
  Future<StockBatchModel> createStockBatch(StockBatchModel batch) async {
    await batchBox.put(batch.id, batch);
    return batch;
  }

  @override
  Future<List<StockBatchModel>> getAllStockBatches() async {
    return batchBox.values.toList();
  }

  @override
  Future<List<StockBatchModel>> getStockBatchesForProduct(
    String productId,
  ) async {
    return batchBox.values.where((e) => e.productId == productId).toList();
  }

  @override
  Future<void> clearStockMovements() async {
    await movementBox.clear();
  }

  @override
  Future<void> clearStockBatches() async {
    await batchBox.clear();
  }

  @override
  Future<void> replaceStockMovementsForProduct(
    String productId,
    List<StockMovementModel> movements,
  ) async {
    final keysToDelete = movementBox.values
        .where((e) => e.productId == productId)
        .map((e) => e.key)
        .toList();

    await movementBox.deleteAll(keysToDelete);

    for (final movement in movements) {
      await movementBox.put(movement.id, movement);
    }
  }

  @override
  Future<void> replaceStockBatchesForProduct(
    String productId,
    List<StockBatchModel> batches,
  ) async {
    final keysToDelete = batchBox.values
        .where((e) => e.productId == productId)
        .map((e) => e.key)
        .toList();

    await batchBox.deleteAll(keysToDelete);

    for (final batch in batches) {
      await batchBox.put(batch.id, batch);
    }
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    await stockBox.put(stock.id, stock);
    return stock;
  }

  @override
  Future<StockBatchModel> updateStockBatch(StockBatchModel batch) async {
    await batchBox.put(batch.id, batch);
    return batch;
  }

  // ======================================================
  // Daily Fetch Gate
  // ======================================================

  @override
  Future<DateTime?> getLastFetchedAt(String key) async {
    final raw = metaBox.get('stock_last_fetched_$key') as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> setLastFetchedAt(String key, DateTime time) async {
    await metaBox.put('stock_last_fetched_$key', time.toIso8601String());
  }

  // ======================================================
  // Purchases
  // ======================================================

  @override
  Future<PurchaseModel> createPurchase(PurchaseModel purchase) async {
    debugPrint("Purchase Saved locally");
    await purchaseBox.put(purchase.id, purchase);
    return purchase;
  }

  @override
  Future<List<PurchaseModel>> getAllPurchases() async {
    return purchaseBox.values.toList();
  }

  @override
  Future<List<PurchaseModel>> getPurchasesForProduct(String productId) async {
    return purchaseBox.values.where((e) => e.productId == productId).toList();
  }

  @override
  Future<void> replacePurchasesForProduct(
    String productId,
    List<PurchaseModel> purchases,
  ) async {
    final keysToDelete = purchaseBox.values
        .where((e) => e.productId == productId)
        .map((e) => e.key)
        .toList();

    await purchaseBox.deleteAll(keysToDelete);

    for (final purchase in purchases) {
      await purchaseBox.put(purchase.id, purchase);
    }
  }

  @override
  Future<void> clearPurchases() async {
    await purchaseBox.clear();
  }

  // ======================================================
  // Utilities
  // ======================================================

  @override
  Future<void> clear() async {
    await Future.wait([
      stockBox.clear(),
      movementBox.clear(),
      batchBox.clear(),
      purchaseBox.clear(),
    ]);
  }
}
