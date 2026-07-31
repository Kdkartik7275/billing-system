import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';

import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class SearchProductsParams {
  final String query;
  const SearchProductsParams(this.query);
}

class SearchProductsUseCase
    implements UseCaseWithParams<List<ProductEntity>, SearchProductsParams> {
  final ProductRepository repository;

  const SearchProductsUseCase(this.repository);

  @override
  ResultFuture<List<ProductEntity>> call(SearchProductsParams params) async {
    if (params.query.trim().isEmpty) {
      return await repository.getAllProducts();
    }
    return await repository.searchProducts(params.query.trim());
  }
}
