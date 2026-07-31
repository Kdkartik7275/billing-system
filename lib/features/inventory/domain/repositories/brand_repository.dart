import 'package:billing_system/core/config/constants/typedefs.dart';

import '../entities/brand_entity.dart';

abstract class BrandRepository {
  ResultFuture<List<BrandEntity>> getAllBrands();
  ResultFuture<BrandEntity?> getBrandById(String id);
  ResultFuture<BrandEntity> addBrand(BrandEntity brand);
  ResultFuture<BrandEntity> updateBrand(BrandEntity brand);
  ResultFuture<void> deleteBrand(String id);
  ResultFuture<BrandEntity?> getBrandByName(String name);
}
