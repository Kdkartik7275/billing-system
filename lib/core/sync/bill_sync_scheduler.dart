import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';
import 'package:billing_system/features/billing/domain/usecases/aggregate_sold_quantities_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/reduce_stock_for_sold_products_usecase.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BillSyncScheduler {
  final BillRepository billRepository;
  final AggregateSoldQuantitiesUsecase aggregateSoldQuantitiesUsecase;
  final ReduceStockForSoldProductsUsecase reduceStockForSoldProductsUsecase;
  final Box metaBox;

  BillSyncScheduler({
    required this.billRepository,
    required this.aggregateSoldQuantitiesUsecase,
    required this.reduceStockForSoldProductsUsecase,
    required this.metaBox,
  });

  static const _lastSyncKey = 'last_bill_sync_at';
  static const _syncInterval = Duration(hours: 24);

  Future<void> hydrateIfNeeded() async {
    await billRepository.hydrateFromRemote();
  }

  bool get isDue {
    final lastSync = metaBox.get(_lastSyncKey) as String?;
    if (lastSync == null) return true;

    final lastSyncTime = DateTime.tryParse(lastSync);
    if (lastSyncTime == null) return true;

    return DateTime.now().difference(lastSyncTime) >= _syncInterval;
  }

  Future<void> runIfDue() async {
    if (!isDue) return;
    await runNow();
  }

  Future<void> runNow() async {
    final result = await billRepository.syncPendingBills();

    await result.fold(
      (failure) async {
        // Offline or sync failed — retried on the next check.
      },
      (syncedBills) async {
        await metaBox.put(_lastSyncKey, DateTime.now().toIso8601String());

        if (syncedBills.isEmpty) return;

        // ---------------- REDUCE STOCK, ONCE PER PRODUCT ----------------
        final aggregateResult = await aggregateSoldQuantitiesUsecase(
          syncedBills,
        );

        await aggregateResult.fold(
          (_) async {
            // Aggregation failed — stock reduction skipped this run.
          },
          (aggregates) async {
            if (aggregates.isEmpty) return;
            await reduceStockForSoldProductsUsecase(aggregates);
          },
        );
      },
    );
  }
}