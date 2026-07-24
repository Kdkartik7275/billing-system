import '../entities/brand_entity.dart';

abstract class BrandRepository {
  Future<List<BrandEntity>> getAllBrands();
  Future<BrandEntity?> getBrandById(String id);
  Future<BrandEntity> addBrand(BrandEntity brand);
  Future<BrandEntity> updateBrand(BrandEntity brand);
  Future<void> deleteBrand(String id);
  Stream<List<BrandEntity>> watchBrands();
}
