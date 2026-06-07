import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class UpdateProductUsecase
    implements UseCaseWithParams<InventoryProduct, InventoryProduct> {
  final InventoryRepository repository;

  UpdateProductUsecase({required this.repository});

  @override
  ResultFuture<InventoryProduct> call(InventoryProduct params) async {
    return await repository.updateProduct(params);
  }
}
