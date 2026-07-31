import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BrandRemoteDataSource {
  Future<List<BrandModel>> getAllBrands();

  Future<BrandModel?> getBrandById(String id);

  Future<BrandModel> addBrand(BrandModel brand);

  Future<BrandModel> updateBrand(BrandModel brand);

  Future<void> deleteBrand(String id);
  Future<BrandModel?> getBrandByName(String name);
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final FirebaseFirestore firestore;

  const BrandRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'brands';

  @override
  Future<BrandModel> addBrand(BrandModel brand) async {
    try {
      await firestore.collection(_collection).doc(brand.id).set(brand.toJson());

      return brand;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add brand: $e');
    }
  }

  @override
  Future<void> deleteBrand(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete brand: $e');
    }
  }

  @override
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch brands: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }

  @override
  Future<BrandModel?> getBrandById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return BrandModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch brand: $e');
    }
  }

  @override
  Future<BrandModel> updateBrand(BrandModel brand) async {
    try {
      await firestore
          .collection(_collection)
          .doc(brand.id)
          .update(brand.toJson());

      return brand;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update brand: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update brand: $e');
    }
  }

  @override
  Future<BrandModel?> getBrandByName(String name) async {
    final snapshot = await firestore
        .collection('brands')
        .where('searchName', isEqualTo: name.trim().toLowerCase())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return BrandModel.fromJson(snapshot.docs.first.data());
  }
}
