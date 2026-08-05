import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetProductStockMovementsUsecase
    implements UseCaseWithParams<List<StockMovementEntity>, String> {
  final StockRepository repository;

  GetProductStockMovementsUsecase({required this.repository});
  @override
  ResultFuture<List<StockMovementEntity>> call(String params) async {
    return await repository.getStockMovementsForProduct(params);
  }
}
