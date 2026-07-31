import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();

  Future<CategoryModel?> getCategoryById(String id);

  Future<CategoryModel> addCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'categories';

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      await firestore
          .collection(_collection)
          .doc(category.id)
          .set(category.toJson());

      return category;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return CategoryModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      await firestore
          .collection(_collection)
          .doc(category.id)
          .update(category.toJson());

      return category;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update category: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }
}
