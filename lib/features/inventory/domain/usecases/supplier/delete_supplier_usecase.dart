import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/supplier_repository.dart';

class DeleteSupplierUsecase implements UseCaseWithParams<void, String> {
  final SupplierRepository repository;

  DeleteSupplierUsecase({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteSupplier(params);
  }
}
