import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class CreateStockUsecase
    implements UseCaseWithParams<StockEntity, StockEntity> {
  final StockRepository repository;

  CreateStockUsecase({required this.repository});
  @override
  ResultFuture<StockEntity> call(StockEntity params) async {
    return await repository.createInitialStock(params);
  }
}
