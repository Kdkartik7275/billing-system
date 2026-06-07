import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:hive/hive.dart';

abstract interface class InventoryLocalDataSource {
  Future<void> cacheProducts(List<InventoryProductModel> products);

  Future<List<InventoryProductModel>> getCachedProducts();

  Future<void> addProduct(InventoryProductModel product);
  Future<void> addStockTransaction(StockTransactionModel transaction);
  Future<void> updateProduct(InventoryProductModel product);

  Future<void> clearCache();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Box<InventoryProductModel> box;
  final Box<StockTransactionModel> stockTransactionBox;

  InventoryLocalDataSourceImpl({
    required this.box,
    required this.stockTransactionBox,
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
}
