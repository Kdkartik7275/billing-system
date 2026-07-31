import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/category_repository.dart';

class GetCategoryByIdUsecase
    implements UseCaseWithParams<CategoryEntity?, String> {
  final CategoryRepository repository;

  GetCategoryByIdUsecase({required this.repository});
  @override
  ResultFuture<CategoryEntity?> call(String params) async {
    return await repository.getCategoryById(params);
  }
}
