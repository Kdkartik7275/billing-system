import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();

  Future<CategoryModel?> getCategoryById(String id);

  Future<CategoryModel> addCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);

  Future<void> clear();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Box<CategoryModel> box;

  const CategoryLocalDataSourceImpl({required this.box});

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    await box.put(category.id, category);
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return box.values.toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    return box.get(id);
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    await box.put(category.id, category);
    return category;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
