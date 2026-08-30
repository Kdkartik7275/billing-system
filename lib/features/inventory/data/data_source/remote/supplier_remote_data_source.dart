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
    } on FirebaseException catch (e) {
      throw Exception('Failed to add supplier: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add supplier: $e');
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete supplier: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete supplier: $e');
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
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch suppliers: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch suppliers: $e');
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
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch supplier: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch supplier: $e');
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
    } on FirebaseException catch (e) {
      throw Exception('Failed to update supplier: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update supplier: $e');
    }
  }
}
