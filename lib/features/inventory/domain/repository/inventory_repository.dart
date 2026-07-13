import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';

abstract interface class InventoryRepository {
  // Future<void> addProduct(Product product);

  ResultVoid addProduct(InventoryProduct product);

  ResultFuture<List<InventoryProduct>> getProducts();
  ResultFuture<List<InventoryProduct>> refreshProducts();

  ResultFuture<InventoryProduct> updateProduct(InventoryProduct product);

  ResultFuture<List<StockTransaction>> getMovementLogs(String productId);
  ResultFuture<List<StockBatch>> getStockBatches(String productId);

  ResultVoid syncProducts(List<Map<String, dynamic>> productsData);

  ResultVoid purchaseStock({
    required int quantity,
    required int previousStock,
    required String productId,
    required double purchasePrice,
    required double sellingPrice,
  });
  ResultFuture<List<StockBatch>> getBatchesForProduct(String productId);

}
