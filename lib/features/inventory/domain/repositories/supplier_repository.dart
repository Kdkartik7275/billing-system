import '../entities/supplier_entity.dart';

abstract class SupplierRepository {
  Future<List<SupplierEntity>> getAllSuppliers();
  Future<SupplierEntity?> getSupplierById(String id);
  Future<SupplierEntity> addSupplier(SupplierEntity supplier);
  Future<SupplierEntity> updateSupplier(SupplierEntity supplier);
  Future<void> deleteSupplier(String id);
  Stream<List<SupplierEntity>> watchSuppliers();
}
