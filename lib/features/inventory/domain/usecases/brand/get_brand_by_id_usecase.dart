import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';

class GetBrandByIdUsecase implements UseCaseWithParams<BrandEntity?, String> {
  final BrandRepository repository;

  GetBrandByIdUsecase({required this.repository});
  @override
  ResultFuture<BrandEntity?> call(String params) async {
    return await repository.getBrandById(params);
  }
}
