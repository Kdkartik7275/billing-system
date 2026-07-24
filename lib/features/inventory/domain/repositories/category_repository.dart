import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAllCategories();
  Future<CategoryEntity?> getCategoryById(String id);
  Future<CategoryEntity> addCategory(CategoryEntity category);
  Future<CategoryEntity> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Stream<List<CategoryEntity>> watchCategories();
}
