import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class CreateBillUsecase implements UseCaseWithParams<BillEntity, BillEntity> {
  final BillRepository repository;

  CreateBillUsecase({required this.repository});

  @override
  ResultFuture<BillEntity> call(BillEntity params) async {
    return await repository.createBill(params);
  }
}
