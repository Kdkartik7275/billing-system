import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/bill_repository.dart';

class UpdateBillStatusParams {
  final String id;
  final BillStatus status;

  const UpdateBillStatusParams({required this.id, required this.status});
}

class UpdateBillStatusUsecase
    implements UseCaseWithParams<BillEntity, UpdateBillStatusParams> {
  final BillRepository repository;

  UpdateBillStatusUsecase({required this.repository});

  @override
  ResultFuture<BillEntity> call(UpdateBillStatusParams params) async {
    return await repository.updateBillStatus(params.id, params.status);
  }
}
