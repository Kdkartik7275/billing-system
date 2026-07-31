import 'package:billing_system/core/config/constants/typedefs.dart';
import '../entities/stock_entity.dart';

abstract class StockRepository {
  ResultFuture<List<StockEntity>> getAllStock();

  ResultFuture<StockEntity?> getStockForProduct(
    String productId,
    String warehouseId,
  );

  ResultFuture<StockEntity> createInitialStock(StockEntity stock);
}
