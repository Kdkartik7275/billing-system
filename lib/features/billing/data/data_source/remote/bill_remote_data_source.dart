import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract interface class BillRemoteDataSource {
  Future<List<BillModel>> getAllBills();

  Future<BillModel?> getBillById(String id);
  Future<BillModel?> getBillByInvoiceNo(String invoiceNo);

  Future<List<BillModel>> getBillsByDateRange(DateTime start, DateTime end);
  Future<List<BillModel>> getBillsByDate(DateTime start);

  Future<BillModel> addBill(BillModel bill);

  Future<BillModel> updateBill(BillModel bill);

  Future<void> deleteBill(String id);

  Future<String> getNextBillNumber();
}

class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  final FirebaseFirestore firestore;

  BillRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'bills';
  static const _counterDoc = 'counters/bills';

  @override
  Future<BillModel> addBill(BillModel bill) async {
    try {
      await firestore.collection(_collection).doc(bill.id).set(bill.toJson());

      return bill;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add bill: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add bill: $e');
    }
  }

  @override
  Future<void> deleteBill(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete bill: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete bill: $e');
    }
  }

  @override
  Future<List<BillModel>> getAllBills() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BillModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch bills: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch bills: $e');
    }
  }

  @override
  Future<BillModel?> getBillById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return BillModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch bill: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch bill: $e');
    }
  }

  @override
  Future<List<BillModel>> getBillsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('createdAt', isLessThanOrEqualTo: end.toIso8601String())
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BillModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch bills: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch bills: $e');
    }
  }

  @override
  Future<BillModel> updateBill(BillModel bill) async {
    try {
      await firestore
          .collection(_collection)
          .doc(bill.id)
          .update(bill.toJson());

      return bill;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update bill: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update bill: $e');
    }
  }

  @override
  Future<List<BillModel>> getBillsByDate(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);

      final end = start.add(const Duration(days: 1));

      final snapshot = await firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('createdAt', isLessThan: end.toIso8601String())
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BillModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch bills by date: ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch bills by date: $e');
    }
  }

  @override
  Future<String> getNextBillNumber() async {
    try {
      final docRef = firestore.doc(_counterDoc);

      final nextNumber = await firestore.runTransaction<int>((
        transaction,
      ) async {
        final snapshot = await transaction.get(docRef);

        final current = snapshot.exists
            ? (snapshot.data()?['lastNumber'] as int? ?? 0)
            : 0;

        final next = current + 1;

        transaction.set(docRef, {'lastNumber': next});

        return next;
      });

      return 'INV-${nextNumber.toString().padLeft(6, '0')}';
    } on FirebaseException catch (e) {
      throw Exception('Failed to generate bill number: ${e.message}');
    } catch (e) {
      throw Exception('Failed to generate bill number: $e');
    }
  }

  @override
  Future<BillModel?> getBillByInvoiceNo(String invoiceNo) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('billNumber', isEqualTo: invoiceNo)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return BillModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch bill: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch bill: $e');
    }
  }
}
