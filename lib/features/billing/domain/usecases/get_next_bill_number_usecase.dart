import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class GetNextBillNumberUsecase implements UseCaseWithoutParams<String> {
  final BillRepository repository;

  GetNextBillNumberUsecase({required this.repository});

  @override
  ResultFuture<String> call() async {
    return await repository.getNextBillNumber();
  }
}
