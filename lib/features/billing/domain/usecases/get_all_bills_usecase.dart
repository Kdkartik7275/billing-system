import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class GetAllBillsUsecase implements UseCaseWithoutParams<List<BillEntity>> {
  final BillRepository repository;

  GetAllBillsUsecase({required this.repository});

  @override
  ResultFuture<List<BillEntity>> call() async {
    return await repository.getAllBills();
  }
}
