import 'dart:async';

import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';
import 'package:billing_system/features/billing/domain/usecases/aggregate_sold_quantities_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/reduce_stock_for_sold_products_usecase.dart';
import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StockReductionEvent {
  final String productId;
  final double newQuantity;

  const StockReductionEvent({
    required this.productId,
    required this.newQuantity,
  });
}

class BillSyncScheduler {
  final BillRepository billRepository;
  final AggregateSoldQuantitiesUsecase aggregateSoldQuantitiesUsecase;
  final ReduceStockForSoldProductsUsecase reduceStockForSoldProductsUsecase;
  final StockRepository stockRepository;
  final Box metaBox;

  BillSyncScheduler({
    required this.billRepository,
    required this.aggregateSoldQuantitiesUsecase,
    required this.reduceStockForSoldProductsUsecase,
    required this.stockRepository,
    required this.metaBox,
  });

  static const _lastSyncKey = 'last_bill_sync_at';
  static const _syncInterval = Duration(hours: 24);

  final _stockReductionsController =
      StreamController<List<StockReductionEvent>>.broadcast();

  Stream<List<StockReductionEvent>> get stockReductions =>
      _stockReductionsController.stream;

  void dispose() {
    _stockReductionsController.close();
  }

  /// Returns the hydration outcome instead of swallowing it, so a caller
  /// can tell "there are genuinely no bills" apart from "we could not ask".
  /// Discarding this was why a failed restore after a reinstall showed up
  /// as a silently empty dashboard with no error and no retry.
  ResultFuture<void> hydrateIfNeeded() {
    return billRepository.hydrateFromRemote();
  }

  bool get isDue {
    final lastSync = metaBox.get(_lastSyncKey) as String?;
    if (lastSync == null) return true;

    final lastSyncTime = DateTime.tryParse(lastSync);
    if (lastSyncTime == null) return true;

    return DateTime.now().difference(lastSyncTime) >= _syncInterval;
  }

  Future<void> runIfDue() async {
    // A pending bill overrides the interval. The 24-hour gate is a cap on
    // routine reconciliation, not a reason to leave a sale sitting on one
    // device: if the at-sale push failed (offline, or the app was killed
    // mid-request), waiting out the rest of the window is exactly how a
    // bill ends up existing nowhere but local storage.
    if (!isDue && !await _hasPendingBills()) return;
    await runNow();
  }

  Future<bool> _hasPendingBills() async {
    final result = await billRepository.getUnsyncedBills();
    return result.fold((_) => false, (bills) => bills.isNotEmpty);
  }

  Future<void> runNow() async {
    final result = await billRepository.syncPendingBills();

    await result.fold(
      (failure) async {
        // Offline or sync failed — retried on the next check.
      },
      (syncedBills) async {
        // Remote state is now committed. Everything past this point
        // is best-effort local bookkeeping and must never throw
        // back out of runNow(), or callers may mistake a UI-side
        // failure for a sync failure and retry a sync that already
        // succeeded remotely.
        await metaBox.put(_lastSyncKey, DateTime.now().toIso8601String());

        if (syncedBills.isNotEmpty) {
          // Bills whose stock was already deducted at sale time only need
          // their local quantity mirrored upstream — never subtracted
          // again. Absolute, so replaying it is harmless.
          final locallyAppliedProductIds = syncedBills
              .where((bill) => bill.stockApplied)
              .expand((bill) => bill.items.map((item) => item.productId))
              .toSet()
              .toList();

          if (locallyAppliedProductIds.isNotEmpty) {
            await stockRepository.pushLocalStockToRemote(
              locallyAppliedProductIds,
            );
          }

          final aggregateResult = await aggregateSoldQuantitiesUsecase(
            syncedBills,
          );

          await aggregateResult.fold((_) async {}, (aggregates) async {
            if (aggregates.isEmpty) return;

            final reductionResult = await reduceStockForSoldProductsUsecase.call(
              aggregates,
            );

            reductionResult.fold((_) {}, (reductions) {
              // Emit the event regardless of whether anyone is
              // listening right now. Guard it too: a broadcast
              // stream with a bad/disposed listener can still
              // rethrow synchronously into the emitter in some
              // edge cases (e.g. listener throwing in onData),
              // and this call must never be allowed to abort
              // pruneOldLocalBills() below.
              try {
                final events = reductions
                    .map(
                      (r) => StockReductionEvent(
                        productId: r.productId,
                        newQuantity: r.newQuantity,
                      ),
                    )
                    .toList();
                _stockReductionsController.add(events);
              } catch (_) {
                // UI notification failed — stock was already
                // reduced in the persisted/local data source by
                // reduceStockForSoldProductsUsecase. This is a
                // display-sync issue, not a data issue, so it
                // must not abort the run.
              }
            });
          });
        }

        await billRepository.pruneOldLocalBills();
      },
    );
  }
}
