import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/category_repository.dart';

class GetCategoriesUsecase
    implements UseCaseWithoutParams<List<CategoryEntity>> {
  final CategoryRepository repository;

  GetCategoriesUsecase({required this.repository});
  @override
  ResultFuture<List<CategoryEntity>> call() async {
    return await repository.getAllCategories();
  }
}
