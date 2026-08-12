import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UnitRemoteDataSource {
  Future<List<UnitModel>> getAllUnits();

  Future<UnitModel?> getUnitById(String id);

  Future<UnitModel> addUnit(UnitModel unit);

  Future<UnitModel> updateUnit(UnitModel unit);

  Future<void> deleteUnit(String id);
}

class UnitRemoteDataSourceImpl implements UnitRemoteDataSource {
  final FirebaseFirestore firestore;

  UnitRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'units';

  @override
  Future<UnitModel> addUnit(UnitModel unit) async {
    try {
      await firestore.collection(_collection).doc(unit.id).set(unit.toMap());

      return unit;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add unit: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add unit: $e');
    }
  }

  @override
  Future<void> deleteUnit(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete unit: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete unit: $e');
    }
  }

  @override
  Future<List<UnitModel>> getAllUnits() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => UnitModel.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch units: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch units: $e');
    }
  }

  @override
  Future<UnitModel?> getUnitById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return UnitModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch unit: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch unit: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(UnitModel unit) async {
    try {
      await firestore.collection(_collection).doc(unit.id).update(unit.toMap());

      return unit;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update unit: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update unit: $e');
    }
  }
}
