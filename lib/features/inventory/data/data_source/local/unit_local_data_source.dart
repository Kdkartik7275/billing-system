import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class UnitLocalDataSource {
  Future<List<UnitModel>> getAllUnits();

  Future<UnitModel?> getUnitById(String id);

  Future<UnitModel> addUnit(UnitModel unit);

  Future<UnitModel> updateUnit(UnitModel unit);

  Future<void> deleteUnit(String id);
  
  Future<void> clear();
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  final Box<UnitModel> unitBox;

  UnitLocalDataSourceImpl({required this.unitBox});

  @override
  Future<List<UnitModel>> getAllUnits() async {
    try {
      return unitBox.values.toList();
    } catch (e) {
      throw Exception('Failed to fetch units from local storage: $e');
    }
  }

  @override
  Future<UnitModel?> getUnitById(String id) async {
    try {
      return unitBox.get(id);
    } catch (e) {
      throw Exception('Failed to fetch unit: $e');
    }
  }

  @override
  Future<UnitModel> addUnit(UnitModel unit) async {
    try {
      await unitBox.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw Exception('Failed to save unit locally: $e');
    }
  }

  @override
  Future<UnitModel> updateUnit(UnitModel unit) async {
    try {
      await unitBox.put(unit.id, unit);
      return unit;
    } catch (e) {
      throw Exception('Failed to update unit locally: $e');
    }
  }

  @override
  Future<void> deleteUnit(String id) async {
    try {
      await unitBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete unit locally: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await unitBox.clear();
    } catch (e) {
      throw Exception('Failed to clear units from local storage: $e');
    }
  }
}
