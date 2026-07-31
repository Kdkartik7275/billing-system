import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';

class GetBrandsUsecase implements UseCaseWithoutParams<List<BrandEntity>> {
  final BrandRepository repository;

  GetBrandsUsecase({required this.repository});
  @override
  ResultFuture<List<BrandEntity>> call() async {
    return await repository.getAllBrands();
  }
}
