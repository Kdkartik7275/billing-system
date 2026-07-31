import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/category_repository.dart';

class DeleteCategoryUsecase implements UseCaseWithParams<void, String> {
  final CategoryRepository repository;

  DeleteCategoryUsecase({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteCategory(params);
  }
}
