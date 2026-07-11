import 'package:billing_system/core/helper/date.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract interface class BillLocalDataSource {
  Future<BillModel> saveBill(BillModel bill);
  Future<List<BillModel>> getCachedBills(DateTime date);
  Future<List<BillModel>> getPendingBills();
  // Future<List<BillModel>> getCachedBillsLast7Days();
  Future<void> markBillsAsSynced(List<String> billIds);
}

class BillLocalDataSourceImpl implements BillLocalDataSource {
  final Box<BillModel> box;

  BillLocalDataSourceImpl({required this.box});

  @override
  Future<BillModel> saveBill(BillModel bill) async {
    await box.put(bill.id, bill);
    return bill;
  }

  @override
  Future<List<BillModel>> getCachedBills(DateTime date) async {
    final bills = box.values
        .where((bill) => isSameDate(bill.createdAt, date))
        .toList();
    debugPrint(
      'Fetched ${bills.length} bills from local cache for date: $date',
    );
    return bills;
  }

  @override
  Future<void> markBillsAsSynced(List<String> billIds) async {
    for (var billId in billIds) {
      final bill = box.get(billId);
      if (bill != null) {
        final updatedBill = bill.copyWith(isOfflineCreated: false);
        await box.put(billId, updatedBill);
      }
    }
  }

  @override
  Future<List<BillModel>> getPendingBills() async {
    return box.values.where((bill) => bill.isOfflineCreated == true).toList();
  }

  // @override
  // Future<List<BillModel>> getCachedBillsLast7Days() async {
  //   final now = DateTime.now();
  //   final sevenDaysAgo = now.subtract(const Duration(days: 7));

  //   final bills = box.values
  //       .where(
  //         (bill) =>
  //             bill.createdAt.isAfter(sevenDaysAgo) &&
  //             bill.createdAt.isBefore(now),
  //       )
  //       .toList();

  //   debugPrint(
  //     'Fetched ${bills.length} bills from local cache for the last 7 days',
  //   );

  //   return bills;
  // }
}
