import '../repositories/product_repository.dart';
import 'usecase.dart';

class DeleteProductUseCase implements UseCase<void, String> {
  final ProductRepository repository;

  const DeleteProductUseCase(this.repository);

  @override
  Future<void> call(String params) {
    return repository.deleteProduct(params);
  }
}
