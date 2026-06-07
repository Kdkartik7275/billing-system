import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';

class GetLastSevenDaysSales implements UseCaseWithoutParams<List<BillEntity>> {
  final BillingRepository repository;

  GetLastSevenDaysSales({required this.repository});
  @override
  ResultFuture<List<BillEntity>> call() async {
    return await repository.getBillsLast7Days();
  }
}
