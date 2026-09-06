import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class SupplierRemoteDataSource {
  Future<List<SupplierModel>> getAllSuppliers();

  Future<SupplierModel?> getSupplierById(String id);

  Future<SupplierModel> addSupplier(SupplierModel supplier);

  Future<SupplierModel> updateSupplier(SupplierModel supplier);

  Future<void> deleteSupplier(String id);
}

class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  final FirebaseFirestore firestore;

  SupplierRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'suppliers';

  @override
  Future<SupplierModel> addSupplier(SupplierModel supplier) async {
    try {
      await firestore
          .collection(_collection)
          .doc(supplier.id)
          .set(supplier.toJson());

      return supplier;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.addSupplier',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.addSupplier',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.deleteSupplier',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.deleteSupplier',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<SupplierModel>> getAllSuppliers() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => SupplierModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.getAllSuppliers',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.getAllSuppliers',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<SupplierModel?> getSupplierById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return SupplierModel.fromJson(doc.data()!);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.getSupplierById',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.getSupplierById',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<SupplierModel> updateSupplier(SupplierModel supplier) async {
    try {
      await firestore
          .collection(_collection)
          .doc(supplier.id)
          .update(supplier.toJson());

      return supplier;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.updateSupplier',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'SupplierRemoteDataSourceImpl.updateSupplier',
      );
      throw TFirebaseException('unknown');
    }
  }
}
