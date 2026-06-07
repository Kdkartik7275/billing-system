import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';

class GetBillsUsecase implements UseCaseWithParams<List<BillEntity>, DateTime> {
  final BillingRepository repository;

  GetBillsUsecase({required this.repository});

  @override
  ResultFuture<List<BillEntity>> call(DateTime params) async {
    return await repository.getBills(params);
  }
}
