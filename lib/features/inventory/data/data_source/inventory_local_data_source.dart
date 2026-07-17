import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:hive/hive.dart';

abstract interface class InventoryLocalDataSource {
  Future<void> cacheProducts(List<InventoryProductModel> products);
  Future<void> cacheMovements(List<StockTransactionModel> movements);
  Future<void> cacheStockBatches(List<StockBatchModel> batches);

  Future<List<InventoryProductModel>> getCachedProducts();
  Future<List<InventoryProductModel>> getCachedProductsByIds(
    List<String> productIds,
  );
  Future<List<StockTransactionModel>> getCachedMovements(String productId);
  Future<List<StockBatchModel>> getStockBatches(String productId);

  Future<void> addProduct(InventoryProductModel product);
  Future<void> addStockTransaction(StockTransactionModel transaction);
  Future<void> addStockBatch(StockBatchModel stockBatch);
  Future<void> updateProduct(InventoryProductModel product);
  Future<void> updateProductStock(String productId, int newStock);

  Future<void> clearCache();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Box<InventoryProductModel> box;
  final Box<StockTransactionModel> stockTransactionBox;
  final Box<StockBatchModel> stockBatchBox;

  InventoryLocalDataSourceImpl({
    required this.box,
    required this.stockTransactionBox,
    required this.stockBatchBox,
  });

  @override
  Future<void> addProduct(InventoryProductModel product) async {
    await box.put(product.id, product);
  }

  @override
  Future<void> cacheProducts(List<InventoryProductModel> products) async {
    await box.clear();

    for (final product in products) {
      await box.put(product.id, product);
    }
  }

  @override
  Future<List<InventoryProductModel>> getCachedProducts() async {
    return box.values.toList();
  }

  @override
  Future<void> clearCache() async {
    await box.clear();
  }

  @override
  Future<void> updateProduct(InventoryProductModel product) async {
    await box.put(product.id, product);
  }

  @override
  Future<void> addStockTransaction(StockTransactionModel transaction) async {
    await stockTransactionBox.add(transaction);
  }

  @override
  Future<void> cacheMovements(List<StockTransactionModel> movements) async {
    await box.clear();

    for (final movement in movements) {
      await stockTransactionBox.put(movement.id, movement);
    }
  }

  @override
  Future<List<StockTransactionModel>> getCachedMovements(
    String productId,
  ) async {
    return stockTransactionBox.values
        .where((movement) => movement.productId == productId)
        .toList();
  }

  @override
  Future<void> addStockBatch(StockBatchModel stockBatch) async {
    await stockBatchBox.add(stockBatch);
  }

  @override
  Future<void> cacheStockBatches(List<StockBatchModel> batches) async {
    await stockBatchBox.clear();
    for (final batch in batches) {
      await stockBatchBox.put(batch.id, batch);
    }
  }

  @override
  Future<List<StockBatchModel>> getStockBatches(String productId) async {
    return stockBatchBox.values
        .where((st) => st.productId == productId)
        .toList();
  }

  @override
  Future<void> updateProductStock(String productId, int newStock) async {
    final product = box.get(productId);
    if (product != null) {
      final updatedProduct = product.copyWith(stock: newStock);
      await box.put(productId, updatedProduct);
    }
  }

  @override
  Future<List<InventoryProductModel>> getCachedProductsByIds(
    List<String> productIds,
  ) async {
    return box.values
        .where((product) => productIds.contains(product.id))
        .toList();
  }
}
