import 'dart:async';

import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/core/sync/sync_status.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_unsynced_bills_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/sync_pending_bills_usecase.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SyncStatusService extends GetxService {
  final GetUnsyncedBillsUsecase getUnsyncedBillsUsecase;
  final SyncPendingBillsUsecase syncPendingBillsUsecase;
  final ConnectionChecker connectionChecker;
  final Box metaBox;

  SyncStatusService({
    required this.getUnsyncedBillsUsecase,
    required this.syncPendingBillsUsecase,
    required this.connectionChecker,
    required this.metaBox,
  });

  static const _lastSyncKey = 'last_bill_sync_at';

  final status = SyncStatus.online.obs;
  final pendingBills = <BillEntity>[].obs;
  final lastSyncedAt = Rx<DateTime?>(null);

  Timer? _poll;

  @override
  void onInit() {
    super.onInit();
    _loadLastSyncedAt();
    refreshNow();
    // Fallback for connectivity flips / bills created elsewhere. Any
    // screen that creates or syncs bills should also call refreshNow()
    // directly for instant feedback — this timer just guarantees the
    // indicator is never more than 20s stale.
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => refreshNow());
  }

  @override
  void onClose() {
    _poll?.cancel();
    super.onClose();
  }

  void _loadLastSyncedAt() {
    final raw = metaBox.get(_lastSyncKey) as String?;
    if (raw == null) return;
    lastSyncedAt.value = DateTime.tryParse(raw);
  }

  /// Cheap refresh: just re-checks pending count + connectivity, does not
  /// attempt a push. Safe to call often (e.g. after navigation).
  Future<void> refreshNow() async {
    final result = await getUnsyncedBillsUsecase();
    result.fold(
      (_) {
        // Could not read local bills — leave status as-is rather than
        // guessing; this is a local read and failing it is unusual.
      },
      (bills) {
        pendingBills.assignAll(bills);
        _recomputeStatus(justAttemptedSync: false);
      },
    );
  }

  /// Full attempt: pushes pending bills now (same usecase the scheduler
  /// uses), then recomputes status. This is what "Retry now" calls.
  Future<void> retryNow() async {
    if (status.value == SyncStatus.syncing) return;
    status.value = SyncStatus.syncing;

    final result = await syncPendingBillsUsecase();

    await result.fold(
      (_) async {
        // Offline or the push itself failed outright — refresh pending
        // count so the UI reflects reality either way.
        await refreshNow();
      },
      (_) async {
        await metaBox.put(_lastSyncKey, DateTime.now().toIso8601String());
        _loadLastSyncedAt();
        await refreshNow();
      },
    );

    if (status.value == SyncStatus.syncing) {
      // refreshNow() didn't move it off syncing (e.g. pending is now 0
      // via the online-branch below) — recompute defensively.
      _recomputeStatus(justAttemptedSync: true);
    }
  }

  Future<void> _recomputeStatus({required bool justAttemptedSync}) async {
    if (status.value == SyncStatus.syncing && !justAttemptedSync) return;

    final online = await connectionChecker.isConnected;

    if (pendingBills.isEmpty) {
      status.value = SyncStatus.online;
      return;
    }

    if (!online) {
      status.value = SyncStatus.offlinePending;
      return;
    }

    // Online with bills still pending: either we just tried and some
    // didn't go through, or something failed silently earlier.
    status.value = justAttemptedSync
        ? SyncStatus.failing
        : SyncStatus.offlinePending; // treat as "will retry" until proven stuck
  }
}
