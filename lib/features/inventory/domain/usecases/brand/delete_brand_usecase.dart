import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';

class DeleteBrandUsecase implements UseCaseWithParams<void, String> {
  final BrandRepository repository;

  DeleteBrandUsecase({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteBrand(params);
  }
}
