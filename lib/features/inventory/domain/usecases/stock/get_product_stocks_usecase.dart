import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetProductStocksUsecase
    implements UseCaseWithParams<StockEntity?, GetProductStocksParams> {
  final StockRepository repository;

  GetProductStocksUsecase({required this.repository});
  @override
  ResultFuture<StockEntity?> call(GetProductStocksParams params) async {
    return await repository.getStockForProduct(params.productId);
  }
}

class GetProductStocksParams {
  final String productId;
  final String warehouseId;

  GetProductStocksParams({required this.productId, required this.warehouseId});
}
