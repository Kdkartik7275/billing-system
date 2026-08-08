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

  // ---------------- CREATE — LOCAL ONLY, NEVER TOUCHES NETWORK ----------------

  @override
  ResultFuture<BillEntity> createBill(BillEntity bill) async {
    try {
      final model = BillModel.fromEntity(bill.copyWith(synced: false));

      final result = await localDataSource.addBill(model);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
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

  // ---------------- HYDRATE — ONE-TIME PULL-BACK AFTER REINSTALL ----------------

  @override
  ResultFuture<void> hydrateFromRemote() async {
    try {
      final alreadyHydrated = await localDataSource.isHydrated();
      if (alreadyHydrated) return const Right(null);

      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(
            message:
                'No Internet Connection. Bill history will be restored once online.',
          ),
        );
      }

      final remoteBills = await remoteDataSource.getBillsForOutlet();

      final syncedModels = remoteBills
          .map((bill) => bill.copyWith(synced: true))
          .toList();

      await localDataSource.saveAllBills(syncedModels);
      await localDataSource.setHydrated();

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
