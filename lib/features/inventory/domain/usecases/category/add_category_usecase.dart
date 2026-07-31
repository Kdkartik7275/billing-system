import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/category_repository.dart';

class AddCategoryUsecase
    implements UseCaseWithParams<CategoryEntity, CategoryEntity> {
  final CategoryRepository repository;

  AddCategoryUsecase({required this.repository});
  @override
  ResultFuture<CategoryEntity> call(CategoryEntity params) async {
    return await repository.addCategory(params);
  }
}
