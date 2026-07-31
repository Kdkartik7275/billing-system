import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BrandLocalDataSource {
  Future<List<BrandModel>> getAllBrands();

  Future<BrandModel?> getBrandById(String id);

  Future<BrandModel> addBrand(BrandModel brand);

  Future<BrandModel> updateBrand(BrandModel brand);
  Future<BrandModel?> getBrandByName(String name);
  Future<void> deleteBrand(String id);

  Future<void> clear();
}

class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  final Box<BrandModel> box;

  const BrandLocalDataSourceImpl({required this.box});

  @override
  Future<BrandModel> addBrand(BrandModel brand) async {
    await box.put(brand.id, brand);
    return brand;
  }

  @override
  Future<void> deleteBrand(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<BrandModel>> getAllBrands() async {
    return box.values.toList();
  }

  @override
  Future<BrandModel?> getBrandById(String id) async {
    return box.get(id);
  }

  @override
  Future<BrandModel?> getBrandByName(String name) async {
    try {
      return box.values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BrandModel> updateBrand(BrandModel brand) async {
    await box.put(brand.id, brand);
    return brand;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
