import 'package:billing_system/core/config/constants/typedefs.dart';

import '../entities/supplier_entity.dart';

abstract class SupplierRepository {
  ResultFuture<List<SupplierEntity>> getAllSuppliers();
  ResultFuture<SupplierEntity?> getSupplierById(String id);
  ResultFuture<SupplierEntity> addSupplier(SupplierEntity supplier);
  ResultFuture<SupplierEntity> updateSupplier(SupplierEntity supplier);
  ResultFuture<void> deleteSupplier(String id);
}
