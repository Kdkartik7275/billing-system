import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';

import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class GetProductsUseCase implements UseCaseWithoutParams<List<ProductEntity>> {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  @override
  ResultFuture<List<ProductEntity>> call() async {
    return await repository.getAllProducts();
  }
}
