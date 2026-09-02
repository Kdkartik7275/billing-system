import 'dart:async';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/billing/data/data_source/local/bill_local_data_source.dart';
import 'package:billing_system/features/billing/data/data_source/remote/bill_remote_data_source.dart';
import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';
import 'package:fpdart/fpdart.dart';

class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remoteDataSource;
  final BillLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  BillRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  // ---------------- CREATE — LOCAL FIRST, THEN BEST-EFFORT PUSH ----------------

  @override
  ResultFuture<BillEntity> createBill(BillEntity bill) async {
    try {
      final model = BillModel.fromEntity(bill.copyWith(synced: false));

      final result = await localDataSource.addBill(model);

      // The local write is what the sale depends on, so it stays the only
      // awaited step — checkout must never wait on, or fail because of,
      // the network. The push is fired off separately: previously the
      // only path to the server was the once-daily scheduler, so a bill
      // could live for up to 24 hours on a single device and was lost for
      // good if the app was uninstalled before then.
      unawaited(_pushInBackground(result.id));

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  Future<void> _pushInBackground(String billId) async {
    try {
      await pushBillNow(billId);
    } catch (_) {
      // Still queued locally as unsynced; the scheduler retries it.
    }
  }

  // ---------------- READS — LOCAL ONLY ----------------

  @override
  ResultFuture<List<BillEntity>> getAllBills() async {
    try {
      final localBills = await localDataSource.getAllBills();
      return right(localBills.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<BillEntity?> getBillById(String id) async {
    try {
      final local = await localDataSource.getBillById(id);
      return right(local?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getBillsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final localBills = await localDataSource.getBillsByDateRange(start, end);
      return right(localBills.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getUnsyncedBills() async {
    try {
      final unsynced = await localDataSource.getUnsyncedBills();
      return right(unsynced.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- STATUS UPDATE — LOCAL ONLY, RE-QUEUES FOR SYNC ----------------

  @override
  ResultFuture<BillEntity> updateBillStatus(
    String id,
    BillStatus status,
  ) async {
    try {
      final existing = await localDataSource.getBillById(id);

      if (existing == null) {
        return left(FirebaseFailure(message: 'Bill not found'));
      }

      final updatedModel = existing.copyWith(
        status: status,
        updatedAt: DateTime.now(),
        synced: false,
      );

      final updated = await localDataSource.updateBill(updatedModel);

      return right(updated.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- DELETE — LOCAL ONLY ----------------

  @override
  ResultFuture<void> deleteBill(String id) async {
    try {
      await localDataSource.deleteBill(id);
      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- BILL NUMBER — GENERATED LOCALLY, WORKS OFFLINE ----------------

  @override
  ResultFuture<String> getNextBillNumber() async {
    try {
      final number = await localDataSource.getNextBillNumber();
      return right(number);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- PUSH SYNC — CALLED ONCE DAILY BY THE SCHEDULER ----------------

  @override
  ResultFuture<List<BillEntity>> syncPendingBills() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final unsynced = await localDataSource.getUnsyncedBills();
      final syncedBills = <BillEntity>[];

      for (final bill in unsynced) {
        try {
          await remoteDataSource.addBill(bill);
          await localDataSource.markBillSynced(bill.id);
          syncedBills.add(bill.copyWith(synced: true).toEntity());
        } catch (_) {
          // Leave unsynced — retried on the next sync run.
        }
      }

      return right(syncedBills);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- HYDRATE — PULL-BACK AFTER REINSTALL ----------------

  @override
  ResultFuture<void> hydrateFromRemote() async {
    try {
      // The hydration flag lives in `billing_meta` while the bills live in
      // the `bills` box, so the two can drift apart — an OS-level backup
      // restore, a partial wipe, or the 30-day prune can each leave the
      // flag set over an empty box. Treating the flag alone as proof of
      // hydration turned that into a permanent empty dashboard, because
      // nothing ever asked the server again. Re-check the actual data.
      final alreadyHydrated = await localDataSource.isHydrated();
      final localBillCount = await localDataSource.countBills();

      if (alreadyHydrated && localBillCount > 0) return const Right(null);

      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(
            message:
                'No Internet Connection. Bill history will be restored once online.',
          ),
        );
      }

      final now = DateTime.now();
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 30));

      final remoteBills = await remoteDataSource.getBillsByDateRange(
        start,
        now,
      );

      final syncedModels = remoteBills
          .map((bill) => bill.copyWith(synced: true))
          .toList();

      await localDataSource.saveAllBills(syncedModels);

      // Only latch the flag once a read genuinely came back with data.
      // An empty result is far more often "we asked too early / the wrong
      // project / before the sale was ever pushed" than a shop with no
      // sales in 30 days, and latching on empty is unrecoverable.
      if (syncedModels.isNotEmpty) {
        await localDataSource.setHydrated();

        for (
          var d = start;
          !d.isAfter(now);
          d = d.add(const Duration(days: 1))
        ) {
          await localDataSource.markDateHydrated(
            DateTime(d.year, d.month, d.day),
          );
        }
      }

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> markStockApplied(String billId) async {
    try {
      await localDataSource.markStockApplied(billId);
      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> pushBillNow(String billId) async {
    try {
      final bill = await localDataSource.getBillById(billId);
      if (bill == null) {
        return left(FirebaseFailure(message: 'Bill not found'));
      }

      if (bill.synced) return const Right(null);

      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      await remoteDataSource.addBill(bill);
      await localDataSource.markBillSynced(billId);

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<int> pruneOldLocalBills() async {
    try {
      final now = DateTime.now();
      final cutoff = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 30));

      final prunedCount = await localDataSource.pruneSyncedBillsOlderThan(
        cutoff,
      );

      return right(prunedCount);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getBillsByDate(DateTime date) async {
    try {
      final localBills = await localDataSource.getBillsByDate(date);

      if (localBills.isNotEmpty) {
        return right(localBills.map((bill) => bill.toEntity()).toList());
      }

      final alreadyHydrated = await localDataSource.isDateHydrated(date);
      if (alreadyHydrated) {
        return const Right([]);
      }

      if (!await connectionChecker.isConnected) {
        return const Right([]);
      }

      final remoteBills = await remoteDataSource.getBillsByDate(date);

      if (remoteBills.isNotEmpty) {
        final localModels = remoteBills
            .map((bill) => bill.copyWith(synced: true))
            .toList();

        await localDataSource.saveAllBills(localModels);
      }

      await localDataSource.markDateHydrated(date);

      return right(remoteBills.map((bill) => bill.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<BillEntity?> getBillByInvoiceNo(String invoiceNo) async {
    try {
      final localbill = await localDataSource.getBillByInvoiceNo(invoiceNo);

      if (localbill != null) {
        return right(localbill.toEntity());
      }
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection!'));
      }
      final remoteBill = await remoteDataSource.getBillByInvoiceNo(invoiceNo);
      if (remoteBill != null) {
        await localDataSource.addBill(remoteBill);
        return right(remoteBill.toEntity());
      }
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
