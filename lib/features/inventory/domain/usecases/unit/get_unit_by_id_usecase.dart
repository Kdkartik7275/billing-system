import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';

class GetUnitByIdUsecase implements UseCaseWithParams<UnitEntity?, String> {
  final UnitRepository repository;

  GetUnitByIdUsecase({required this.repository});
  @override
  ResultFuture<UnitEntity?> call(String params) async {
    return await repository.getUnitById(params);
  }
}
