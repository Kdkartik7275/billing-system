import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class AddProductUsecase implements UseCaseWithParams<void, InventoryProduct> {
  final InventoryRepository repository;

  AddProductUsecase(this.repository);

  @override
  ResultFuture<void> call(InventoryProduct params) async {
    return repository.addProduct(params);
  }
}
