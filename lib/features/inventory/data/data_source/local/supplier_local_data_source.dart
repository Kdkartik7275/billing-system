import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class SupplierLocalDataSource {
  Future<List<SupplierModel>> getAllSuppliers();

  Future<SupplierModel?> getSupplierById(String id);

  Future<SupplierModel> addSupplier(SupplierModel supplier);

  Future<SupplierModel> updateSupplier(SupplierModel supplier);

  Future<void> deleteSupplier(String id);

  Future<void> clear();
}

class SupplierLocalDataSourceImpl implements SupplierLocalDataSource {
  final Box<SupplierModel> box;

  const SupplierLocalDataSourceImpl({required this.box});

  @override
  Future<SupplierModel> addSupplier(SupplierModel supplier) async {
    await box.put(supplier.id, supplier);
    return supplier;
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<SupplierModel>> getAllSuppliers() async {
    return box.values.toList();
  }

  @override
  Future<SupplierModel?> getSupplierById(String id) async {
    return box.get(id);
  }

  @override
  Future<SupplierModel> updateSupplier(SupplierModel supplier) async {
    await box.put(supplier.id, supplier);
    return supplier;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
