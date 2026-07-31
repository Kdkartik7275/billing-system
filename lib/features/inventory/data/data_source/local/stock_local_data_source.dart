import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class StockLocalDataSource {
  Future<List<StockModel>> getAllStock();

  Future<StockModel?> getStockForProduct(String productId, String warehouseId);

  Future<StockModel> createInitialStock(StockModel stock);

  Future<void> clear();
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  final Box<StockModel> box;

  const StockLocalDataSourceImpl({required this.box});

  @override
  Future<StockModel> createInitialStock(StockModel stock) async {
    await box.put(stock.id, stock);
    return stock;
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    return box.values.toList();
  }

  @override
  Future<StockModel?> getStockForProduct(
    String productId,
    String warehouseId,
  ) async {
    try {
      return box.values.firstWhere(
        (stock) =>
            stock.productId == productId && stock.warehouseId == warehouseId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
