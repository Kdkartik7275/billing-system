import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetStocksUsecase implements UseCaseWithoutParams<List<StockEntity>> {
  final StockRepository repository;

  GetStocksUsecase({required this.repository});
  @override
  ResultFuture<List<StockEntity>> call() async {
    return await repository.getAllStock();
  }
}
