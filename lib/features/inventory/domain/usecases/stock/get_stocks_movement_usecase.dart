import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetStocksMovementUsecase
    implements UseCaseWithoutParams<List<StockMovementEntity>> {
  final StockRepository repository;

  GetStocksMovementUsecase({required this.repository});

  @override
  ResultFuture<List<StockMovementEntity>> call() async {
    return await repository.getAllStockMovements();
  }
}
