import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.addBrand',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.addBrand',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<void> deleteBrand(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.deleteBrand',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.deleteBrand',
      );
      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getAllBrands',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getAllBrands',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<BrandModel?> getBrandById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return BrandModel.fromJson(doc.data()!);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getBrandById',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getBrandById',
      );
      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.updateBrand',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.updateBrand',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<BrandModel?> getBrandByName(String name) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('searchName', isEqualTo: name.trim().toLowerCase())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return BrandModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getBrandByName',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'BrandRemoteDataSourceImpl.getBrandByName',
      );
      throw TFirebaseException('unknown');
    }
  }
}
