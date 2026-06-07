import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class RefreshProductsUsecase
    implements UseCaseWithoutParams<List<InventoryProduct>> {
  final InventoryRepository repository;

  RefreshProductsUsecase(this.repository);

  @override
  ResultFuture<List<InventoryProduct>> call() async {
    return await repository.refreshProducts();
  }
}
