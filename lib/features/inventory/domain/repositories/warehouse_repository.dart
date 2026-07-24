import '../entities/warehouse_entity.dart';

abstract class WarehouseRepository {
  Future<List<WarehouseEntity>> getAllWarehouses();
  Future<WarehouseEntity?> getWarehouseById(String id);
  Future<WarehouseEntity> addWarehouse(WarehouseEntity warehouse);
  Future<WarehouseEntity> updateWarehouse(WarehouseEntity warehouse);
  Future<void> deleteWarehouse(String id);
  Stream<List<WarehouseEntity>> watchWarehouses();
}
