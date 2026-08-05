import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class CreateStockMovementUsecase
    implements UseCaseWithParams<StockMovementEntity, StockMovementEntity> {
  final StockRepository repository;

  CreateStockMovementUsecase({required this.repository});

  @override
  ResultFuture<StockMovementEntity> call(StockMovementEntity params) async {
    return await repository.createStockMovement(params);
  }
}
