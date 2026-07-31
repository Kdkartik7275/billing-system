import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';

class GetProductUsecase implements UseCaseWithParams<ProductEntity?, String> {
  final ProductRepository repository;

  GetProductUsecase({required this.repository});
  @override
  ResultFuture<ProductEntity?> call(String params) async {
    return await repository.getProductById(params);
  }
}
