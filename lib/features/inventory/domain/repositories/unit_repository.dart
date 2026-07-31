import 'package:billing_system/core/config/constants/typedefs.dart';

import '../entities/unit_entity.dart';

abstract class UnitRepository {
  ResultFuture<List<UnitEntity>> getAllUnits();
  ResultFuture<UnitEntity?> getUnitById(String id);
  ResultFuture<UnitEntity> addUnit(UnitEntity unit);
  ResultFuture<UnitEntity> updateUnit(UnitEntity unit);
  ResultFuture<void> deleteUnit(String id);
}
