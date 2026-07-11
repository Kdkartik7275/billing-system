import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/pos/data/data_source/bill_local_data_source.dart';
import 'package:billing_system/features/pos/data/data_source/bill_remote_data_source.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_item_model.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_model.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';
import 'package:fpdart/fpdart.dart';

class BillRepositoryImpl implements BillingRepository {
  final BillRemoteDataSource remoteDataSource;
  final BillLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;
  BillRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultVoid saveBill(Map<String, dynamic> billData) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   final bill = BillModel(
      //     id: billData['id'],
      //     receiptNumber: billData['receiptNumber'],
      //     createdAt: DateTime.parse(billData['createdAt']),
      //     customerName: billData['customerName'],
      //     customerPhone: billData['customerPhone'],
      //     items: (billData['items'] as List)
      //         .map((item) => BillItemModel.fromMap(item))
      //         .toList(),
      //     subtotal: (billData['subtotal'] as num).toDouble(),
      //     taxRate: (billData['taxRate'] as num).toDouble(),
      //     taxAmount: (billData['taxAmount'] as num).toDouble(),
      //     grandTotal: (billData['grandTotal'] as num).toDouble(),
      //     paymentMethod: billData['paymentMethod'],
      //     amountTendered: (billData['amountTendered'] as num).toDouble(),
      //     changeGiven: (billData['changeGiven'] as num).toDouble(),
      //     status: billData['status'],
      //     createdBy: billData['createdBy'],
      //     isOfflineCreated: true,
      //   );
      //   await localDataSource.saveBill(bill);
      //   return right(null);
      // }
      // final result = await remoteDataSource.saveBill(billData);
      // await localDataSource.saveBill(result);
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
        isOfflineCreated: true,
      );
      await localDataSource.saveBill(bill);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getBills(DateTime date) async {
    try {
      final cachedBills = await localDataSource.getCachedBills(date);

      if (cachedBills.isNotEmpty) {
        return right(cachedBills.map((bill) => bill.toEntity()).toList());
      }

      if (await connectionChecker.isConnected) {
        final remoteBills = await remoteDataSource.getBills(date);

        await Future.wait(
          remoteBills.map((bill) => localDataSource.saveBill(bill)),
        );

        return right(remoteBills.map((bill) => bill.toEntity()).toList());
      }

      return right([]);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid syncPendingBills(List<BillEntity> bills) async {
    try {
      if (bills.isEmpty) return right(null);
      final billModels = bills
          .map((bill) => BillModel.fromEntity(bill))
          .toList();
      await remoteDataSource.syncPendingBills(billModels);
      await localDataSource.markBillsAsSynced(bills.map((b) => b.id).toList());
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getBillsLast7Days() async {
    try {
      final now = DateTime.now();

      final results = await Future.wait(
        List.generate(7, (index) {
          final date = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: index));

          return getBills(date);
        }),
      );

      final List<BillEntity> allBills = [];

      for (final result in results) {
        result.fold((_) {}, (bills) => allBills.addAll(bills));
      }

      return right(allBills);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BillEntity>> getPendingBills() async {
    try {
      final bills = await localDataSource.getPendingBills();

      return right(bills.map((bill) => bill.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
