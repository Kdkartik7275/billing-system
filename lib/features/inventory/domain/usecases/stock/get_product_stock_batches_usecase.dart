import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetProductStockBatchesUsecase
    implements UseCaseWithParams<List<StockBatchEntity>, String> {
  final StockRepository repository;

  GetProductStockBatchesUsecase({required this.repository});

  @override
  ResultFuture<List<StockBatchEntity>> call(String params) async {
    return await repository.getStockBatchesForProduct(params);
  }
}
