import 'package:billing_system/core/config/constants/typedefs.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  ResultFuture<List<CategoryEntity>> getAllCategories();
  ResultFuture<CategoryEntity?> getCategoryById(String id);
  ResultFuture<CategoryEntity> addCategory(CategoryEntity category);
  ResultFuture<CategoryEntity> updateCategory(CategoryEntity category);
  ResultFuture<void> deleteCategory(String id);
}
