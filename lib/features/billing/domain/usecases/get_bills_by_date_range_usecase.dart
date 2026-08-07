import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class DateRangeParams {
  final DateTime start;
  final DateTime end;

  const DateRangeParams({required this.start, required this.end});
}

class GetBillsByDateRangeUsecase
    implements UseCaseWithParams<List<BillEntity>, DateRangeParams> {
  final BillRepository repository;

  GetBillsByDateRangeUsecase({required this.repository});

  @override
  ResultFuture<List<BillEntity>> call(DateRangeParams params) async {
    return await repository.getBillsByDateRange(params.start, params.end);
  }
}
