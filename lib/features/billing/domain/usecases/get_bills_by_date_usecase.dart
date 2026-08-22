import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class GetBillsByDateUsecase
    implements UseCaseWithParams<List<BillEntity>, DateTime> {
  final BillRepository repository;

  GetBillsByDateUsecase({required this.repository});
  @override
  ResultFuture<List<BillEntity>> call(DateTime params) async {
    return await repository.getBillsByDate(params);
  }
}
