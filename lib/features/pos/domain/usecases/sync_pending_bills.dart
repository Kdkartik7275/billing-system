import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';

class SyncPendingBillsUsecase
    implements UseCaseWithParams<void, List<BillEntity>> {
  final BillingRepository repository;

  SyncPendingBillsUsecase({required this.repository});

  @override
  ResultFuture<void> call(List<BillEntity> bills) async {
    return await repository.syncPendingBills(bills);
  }
}
