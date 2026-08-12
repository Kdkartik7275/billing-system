import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';

class UpdateUnitUsecase implements UseCaseWithParams<UnitEntity, UnitEntity> {
  final UnitRepository repository;

  UpdateUnitUsecase({required this.repository});
  @override
  ResultFuture<UnitEntity> call(UnitEntity params) async {
    return await repository.updateUnit(params);
  }
}
