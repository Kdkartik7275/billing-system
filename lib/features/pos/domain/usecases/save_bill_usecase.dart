import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/pos/domain/repository/billing_repository.dart';

class SaveBill implements UseCaseWithParams<void, Map<String, dynamic>> {
  final BillingRepository repository;

  SaveBill(this.repository);

  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    return await repository.saveBill(params);
  }
}
