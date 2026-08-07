import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class DeleteBillUsecase implements UseCaseWithParams<void, String> {
  final BillRepository repository;

  DeleteBillUsecase({required this.repository});

  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteBill(params);
  }
}
