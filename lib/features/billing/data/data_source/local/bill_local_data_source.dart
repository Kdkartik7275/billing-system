import 'dart:math';

import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

abstract interface class BillLocalDataSource {
  Future<List<BillModel>> getAllBills();

  Future<BillModel?> getBillById(String id);

  Future<List<BillModel>> getBillsByDateRange(DateTime start, DateTime end);

  Future<List<BillModel>> getUnsyncedBills();

  Future<BillModel> addBill(BillModel bill);

  Future<void> saveAllBills(List<BillModel> bills);

  Future<BillModel> updateBill(BillModel bill);

  Future<void> markBillSynced(String id);

  Future<void> deleteBill(String id);

  Future<void> clear();

  Future<String> getNextBillNumber();

  Future<bool> isHydrated();

  Future<void> setHydrated();
}

class BillLocalDataSourceImpl implements BillLocalDataSource {
  final Box<BillModel> box;
  final Box metaBox;

  const BillLocalDataSourceImpl({required this.box, required this.metaBox});

  @override
  Future<BillModel> addBill(BillModel bill) async {
    await box.put(bill.id, bill);
    return bill;
  }

  @override
  Future<void> saveAllBills(List<BillModel> bills) async {
    final entries = {for (final bill in bills) bill.id: bill};
    await box.putAll(entries);
  }

  @override
  Future<void> deleteBill(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<BillModel>> getAllBills() async {
    return box.values.toList();
  }

  @override
  Future<BillModel?> getBillById(String id) async {
    return box.get(id);
  }

  @override
  Future<List<BillModel>> getBillsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return box.values
        .where(
          (bill) =>
              bill.createdAt.isAfter(start) && bill.createdAt.isBefore(end),
        )
        .toList();
  }

  @override
  Future<List<BillModel>> getUnsyncedBills() async {
    return box.values.where((bill) => !bill.synced).toList();
  }

  @override
  Future<BillModel> updateBill(BillModel bill) async {
    await box.put(bill.id, bill);
    return bill;
  }

  @override
  Future<void> markBillSynced(String id) async {
    final bill = box.get(id);
    if (bill == null) return;
    await box.put(id, bill.copyWith(synced: true));
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  // ---------------- HYDRATION FLAG ----------------

  @override
  Future<bool> isHydrated() async {
    return (metaBox.get('bills_hydrated') as bool?) ?? false;
  }

  @override
  Future<void> setHydrated() async {
    await metaBox.put('bills_hydrated', true);
  }

  // ---------------- LOCAL BILL NUMBERING ----------------

  @override
  Future<String> getNextBillNumber() async {
    final deviceCode = await _getOrCreateDeviceCode();
    final dateKey = DateFormat('yyyyMMdd').format(DateTime.now());
    final counterKey = 'bill_counter_$dateKey';

    final current = (metaBox.get(counterKey) as int?) ?? 0;
    final next = current + 1;
    await metaBox.put(counterKey, next);

    return 'INV-$deviceCode-$dateKey-${next.toString().padLeft(4, '0')}';
  }

  Future<String> _getOrCreateDeviceCode() async {
    const key = 'device_code';
    final existing = metaBox.get(key) as String?;
    if (existing != null) return existing;

    final code = _generateDeviceCode();
    await metaBox.put(key, code);
    return code;
  }

  String _generateDeviceCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
