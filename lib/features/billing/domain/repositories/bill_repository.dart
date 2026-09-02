import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';

abstract class BillRepository {
  ResultFuture<BillEntity> createBill(BillEntity bill);
  ResultFuture<BillEntity?> getBillById(String id);
  ResultFuture<BillEntity?> getBillByInvoiceNo(String invoiceNo);
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

  /// Records that [billId]'s quantities have already been deducted from
  /// stock, so the sync reconciliation never subtracts them again.
  ResultFuture<void> markStockApplied(String billId);

  /// Best-effort immediate push of a single freshly-created bill.
  ///
  /// Bills are still queued locally and picked up by the daily sync, so a
  /// failure here is not an error the caller needs to handle — this only
  /// shortens the window in which a sale exists on one device and nowhere
  /// else, which is what made bill history unrecoverable after a reinstall.
  ResultFuture<void> pushBillNow(String billId);
}
