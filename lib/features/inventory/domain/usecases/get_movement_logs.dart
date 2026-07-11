import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class GetMovementLogs
    implements UseCaseWithParams<List<StockTransaction>, String> {
  final InventoryRepository repository;

  GetMovementLogs({required this.repository});
  @override
  ResultFuture<List<StockTransaction>> call(String id) async {
    return await repository.getMovementLogs(id);
  }
}
