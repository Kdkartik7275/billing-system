import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';

class AddBrandUsecase implements UseCaseWithParams<BrandEntity, BrandEntity> {
  final BrandRepository repository;

  AddBrandUsecase({required this.repository});
  @override
  ResultFuture<BrandEntity> call(BrandEntity params) async {
    return await repository.addBrand(params);
  }
}
