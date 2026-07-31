import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';

import '../../repositories/product_repository.dart';

class DeleteProductUseCase implements UseCaseWithParams<void, String> {
  final ProductRepository repository;

  const DeleteProductUseCase(this.repository);

  @override
  ResultVoid call(String params) async {
    return await repository.deleteProduct(params);
  }
}
