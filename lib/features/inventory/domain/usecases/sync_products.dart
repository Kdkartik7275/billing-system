import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class SyncProductsUsecase
    implements UseCaseWithParams<void, List<Map<String, dynamic>>> {
  final InventoryRepository repository;

  SyncProductsUsecase({required this.repository});

  @override
  ResultFuture<void> call(List<Map<String, dynamic>> productsData) async {
    return await repository.syncProducts(productsData);
  }
}
