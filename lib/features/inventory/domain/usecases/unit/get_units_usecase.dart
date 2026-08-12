import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';

class GetUnitsUsecase implements UseCaseWithoutParams<List<UnitEntity>> {
  final UnitRepository repository;

  GetUnitsUsecase({required this.repository});
  @override
  ResultFuture<List<UnitEntity>> call() async {
    return await repository.getAllUnits();
  }
}
