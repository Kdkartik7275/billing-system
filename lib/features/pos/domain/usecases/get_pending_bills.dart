import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';

class GetPendingBillsUseCase implements UseCaseWithoutParams<List<BillEntity>> {
  final BillingRepository repository;

  GetPendingBillsUseCase({required this.repository});
  @override
  ResultFuture<List<BillEntity>> call() async {
    return await repository.getPendingBills();
  }
}
