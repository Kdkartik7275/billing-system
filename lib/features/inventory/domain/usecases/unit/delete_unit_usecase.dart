import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';

class DeleteUnitUsecase implements UseCaseWithParams<void, String> {
  final UnitRepository repository;

  DeleteUnitUsecase({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteUnit(params);
  }
}
