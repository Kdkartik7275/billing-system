import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';

import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class UpdateProductUseCase
    implements UseCaseWithParams<ProductEntity, ProductEntity> {
  final ProductRepository repository;

  const UpdateProductUseCase(this.repository);

  @override
  ResultFuture<ProductEntity> call(ProductEntity params) async {
    return await repository.updateProduct(
      params.copyWith(updatedAt: DateTime.now()),
    );
  }
}
