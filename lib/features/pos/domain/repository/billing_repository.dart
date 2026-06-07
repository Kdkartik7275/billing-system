import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';

abstract interface class BillingRepository {
  ResultVoid saveBill(Map<String, dynamic> billData);

  ResultFuture<List<BillEntity>> getBills(DateTime date);
  ResultFuture<List<BillEntity>> getBillsLast7Days();

  ResultVoid syncPendingBills(List<BillEntity> bills);
}
