import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
