import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class GetProductBatchesUsecase
    implements UseCaseWithParams<List<StockBatch>, String> {
  final InventoryRepository repository;
  GetProductBatchesUsecase({required this.repository});
  @override
  ResultFuture<List<StockBatch>> call(String params) async {
    return await repository.getBatchesForProduct(params);
  }
}
