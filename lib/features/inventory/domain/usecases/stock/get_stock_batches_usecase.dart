import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetStockBatchesUsecase
    implements UseCaseWithoutParams<List<StockBatchEntity>> {
  final StockRepository repository;

  GetStockBatchesUsecase({required this.repository});

  @override
  ResultFuture<List<StockBatchEntity>> call() async {
    return await repository.getAllStockBatches();
  }
}
