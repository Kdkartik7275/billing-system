import 'package:billing_system/core/config/constants/typedefs.dart';

import '../entities/warehouse_entity.dart';

abstract class WarehouseRepository {
  ResultFuture<List<WarehouseEntity>> getAllWarehouses();
  ResultFuture<WarehouseEntity?> getWarehouseById(String id);
  ResultFuture<WarehouseEntity> addWarehouse(WarehouseEntity warehouse);
  ResultFuture<WarehouseEntity> updateWarehouse(WarehouseEntity warehouse);
  ResultFuture<void> deleteWarehouse(String id);
}
