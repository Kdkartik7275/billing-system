import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class GetProductsUsecase
    implements UseCaseWithoutParams<List<InventoryProduct>> {
  final InventoryRepository repository;

  GetProductsUsecase(this.repository);

  @override
  ResultFuture<List<InventoryProduct>> call() async {
    return await repository.getProducts();
  }
}
