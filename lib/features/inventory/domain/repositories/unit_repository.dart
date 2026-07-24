import '../entities/unit_entity.dart';

abstract class UnitRepository {
  Future<List<UnitEntity>> getAllUnits();
  Future<UnitEntity?> getUnitById(String id);
  Future<UnitEntity> addUnit(UnitEntity unit);
  Future<UnitEntity> updateUnit(UnitEntity unit);
  Future<void> deleteUnit(String id);
  Stream<List<UnitEntity>> watchUnits();
}
