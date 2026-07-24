import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class UpdateProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  final ProductRepository repository;

  const UpdateProductUseCase(this.repository);

  @override
  Future<ProductEntity> call(ProductEntity params) {
    return repository.updateProduct(
      params.copyWith(updatedAt: DateTime.now()),
    );
  }
}
