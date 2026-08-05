import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class CreateStockBatchUsecase
    implements UseCaseWithParams<StockBatchEntity, StockBatchEntity> {
  final StockRepository repository;

  CreateStockBatchUsecase({required this.repository});

  @override
  ResultFuture<StockBatchEntity> call(StockBatchEntity params) async {
    return await repository.createStockBatch(params);
  }
}
