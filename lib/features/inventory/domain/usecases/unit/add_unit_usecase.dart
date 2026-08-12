import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';

class AddUnitUsecase implements UseCaseWithParams<UnitEntity, UnitEntity> {
  final UnitRepository repository;

  AddUnitUsecase({required this.repository});
  @override
  ResultFuture<UnitEntity> call(UnitEntity params) async {
    return await repository.addUnit(params);
  }
}
