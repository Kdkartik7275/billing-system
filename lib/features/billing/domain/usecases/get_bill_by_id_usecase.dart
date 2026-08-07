import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class GetBillByIdUsecase implements UseCaseWithParams<BillEntity?, String> {
  final BillRepository repository;

  GetBillByIdUsecase({required this.repository});

  @override
  ResultFuture<BillEntity?> call(String params) async {
    return await repository.getBillById(params);
  }
}
