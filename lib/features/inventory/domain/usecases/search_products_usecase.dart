import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class SearchProductsParams {
  final String query;
  const SearchProductsParams(this.query);
}

class SearchProductsUseCase
    implements UseCase<List<ProductEntity>, SearchProductsParams> {
  final ProductRepository repository;

  const SearchProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(SearchProductsParams params) {
    if (params.query.trim().isEmpty) {
      return repository.getAllProducts();
    }
    return repository.searchProducts(params.query.trim());
  }
}
