import 'dart:math';

import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

abstract interface class BillLocalDataSource {
  Future<List<BillModel>> getAllBills();

  Future<BillModel?> getBillById(String id);
  Future<BillModel?> getBillByInvoiceNo(String invoiceNo);
  Future<int> pruneSyncedBillsOlderThan(DateTime before);

  Future<List<BillModel>> getBillsByDateRange(DateTime start, DateTime end);
  Future<List<BillModel>> getBillsByDate(DateTime start);

  Future<List<BillModel>> getUnsyncedBills();

  Future<BillModel> addBill(BillModel bill);

  Future<void> saveAllBills(List<BillModel> bills);

  Future<BillModel> updateBill(BillModel bill);

  Future<void> markBillSynced(String id);

  Future<void> markStockApplied(String id);

  Future<int> countBills();

  Future<void> deleteBill(String id);

  Future<void> clear();

  Future<String> getNextBillNumber();

  Future<bool> isHydrated();

  Future<void> setHydrated();

  Future<bool> isDateHydrated(DateTime date);

  Future<void> markDateHydrated(DateTime date);
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
    // Both bounds are inclusive. Callers pass calendar boundaries such as
    // "midnight six days ago" to "23:59:59 today", and the previous strict
    // isAfter/isBefore pair silently dropped a bill written exactly on
    // either boundary — which for the dashboard's 7-day chart meant the
    // oldest day could come up empty.
    return box.values
        .where(
          (bill) =>
              !bill.createdAt.isBefore(start) && !bill.createdAt.isAfter(end),
        )
        .toList();
  }

  @override
  Future<List<BillModel>> getBillsByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);

    final end = start.add(const Duration(days: 1));

    return box.values
        .where(
          (bill) =>
              !bill.createdAt.isBefore(start) && bill.createdAt.isBefore(end),
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
  Future<void> markStockApplied(String id) async {
    final bill = box.get(id);
    if (bill == null) return;
    await box.put(id, bill.copyWith(stockApplied: true));
  }

  @override
  Future<int> countBills() async {
    return box.length;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  // ---------------- HYDRATION FLAG (BULK 30-DAY PULL) ----------------

  @override
  Future<bool> isHydrated() async {
    return (metaBox.get('bills_hydrated') as bool?) ?? false;
  }

  @override
  Future<void> setHydrated() async {
    await metaBox.put('bills_hydrated', true);
  }

  // ---------------- PER-DATE HYDRATION ----------------

  static const _hydratedDatesKey = 'hydrated_bill_dates';

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Set<String> _readHydratedDates() {
    final raw = metaBox.get(_hydratedDatesKey) as List?;
    if (raw == null) return <String>{};
    return raw.map((e) => e.toString()).toSet();
  }

  @override
  Future<bool> isDateHydrated(DateTime date) async {
    return _readHydratedDates().contains(_dateKey(date));
  }

  @override
  Future<void> markDateHydrated(DateTime date) async {
    final hydratedDates = _readHydratedDates();
    hydratedDates.add(_dateKey(date));
    await metaBox.put(_hydratedDatesKey, hydratedDates.toList());
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

  @override
  Future<int> pruneSyncedBillsOlderThan(DateTime before) async {
    final staleBillIds = box.values
        .where((bill) => bill.synced && bill.createdAt.isBefore(before))
        .map((bill) => bill.id)
        .toList();

    if (staleBillIds.isEmpty) return 0;

    await box.deleteAll(staleBillIds);

    final hydratedDates = _readHydratedDates();
    final beforeCutoffOnly = DateTime(before.year, before.month, before.day);
    final trimmed = hydratedDates.where((key) {
      final parts = key.split('-');
      if (parts.length != 3) return false;
      final keyDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      return !keyDate.isBefore(beforeCutoffOnly);
    }).toSet();

    if (trimmed.length != hydratedDates.length) {
      await metaBox.put(_hydratedDatesKey, trimmed.toList());
    }

    return staleBillIds.length;
  }

  String _generateDeviceCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<BillModel?> getBillByInvoiceNo(String invoiceNo) async {
    // firstWhere without orElse throws on a miss, which defeated the
    // repository's remote fallback for invoices not held locally.
    for (final bill in box.values) {
      if (bill.billNumber == invoiceNo) return bill;
    }
    return null;
  }
}
