import 'package:billing_system/features/pos/data/models/bill/bill_item_model.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BillRemoteDataSource {
  Future<BillModel> saveBill(Map<String, dynamic> billData);
  Future<List<BillModel>> getBills(DateTime date);
  Future<void> syncPendingBills(List<BillModel> bills);
}

class BillRemoteDataSourceImpl implements BillRemoteDataSource {
  final FirebaseFirestore firestore;

  BillRemoteDataSourceImpl({required this.firestore});

  @override
  Future<BillModel> saveBill(Map<String, dynamic> billData) async {
    final bill = BillModel(
      id: billData['id'],
      receiptNumber: billData['receiptNumber'],
      createdAt: DateTime.parse(billData['createdAt']),
      customerName: billData['customerName'],
      customerPhone: billData['customerPhone'],
      items: (billData['items'] as List)
          .map((item) => BillItemModel.fromMap(item))
          .toList(),
      subtotal: (billData['subtotal'] as num).toDouble(),
      taxRate: (billData['taxRate'] as num).toDouble(),
      taxAmount: (billData['taxAmount'] as num).toDouble(),
      grandTotal: (billData['grandTotal'] as num).toDouble(),
      paymentMethod: billData['paymentMethod'],
      amountTendered: (billData['amountTendered'] as num).toDouble(),
      changeGiven: (billData['changeGiven'] as num).toDouble(),
      status: billData['status'],
      createdBy: billData['createdBy'],
      isOfflineCreated: billData['isOfflineCreated'] as bool? ?? false,
    );

    await firestore.collection('bills').doc(bill.id).set(bill.toFirestore());

    final doc = await firestore.collection('bills').doc(bill.id).get();

    return BillModel.fromFirestore(doc);
  }

  @override
  Future<List<BillModel>> getBills(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));

      final querySnapshot = await firestore
          .collection('bills')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThan: Timestamp.fromDate(end))
          .get();

      return querySnapshot.docs
          .map((doc) => BillModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bills: $e');
    }
  }

  @override
  Future<void> syncPendingBills(List<BillModel> bills) async {
    try {
      final batch = firestore.batch();
      for (final bill in bills) {
        final docRef = firestore.collection('bills').doc(bill.id);
        batch.set(docRef, bill.copyWith(isOfflineCreated: false).toFirestore());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to sync pending bills: $e');
    }
  }
}
