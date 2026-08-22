import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';

abstract class BillRepository {
  ResultFuture<BillEntity> createBill(BillEntity bill);
  ResultFuture<BillEntity?> getBillById(String id);
  ResultFuture<List<BillEntity>> getAllBills();
  ResultFuture<List<BillEntity>> getBillsByDateRange(
    DateTime start,
    DateTime end,
  );
  ResultFuture<List<BillEntity>> getBillsByDate(DateTime date);
  ResultFuture<List<BillEntity>> getUnsyncedBills();
  ResultFuture<BillEntity> updateBillStatus(String id, BillStatus status);
  ResultFuture<void> deleteBill(String id);
  ResultFuture<String> getNextBillNumber();
  ResultFuture<List<BillEntity>> syncPendingBills();
  ResultFuture<void> hydrateFromRemote();
  ResultFuture<int> pruneOldLocalBills();
}
