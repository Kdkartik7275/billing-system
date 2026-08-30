import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/supplier_repository.dart';

class AddSupplierUsecase
    implements UseCaseWithParams<SupplierEntity, SupplierEntity> {
  final SupplierRepository repository;

  AddSupplierUsecase({required this.repository});
  @override
  ResultFuture<SupplierEntity> call(SupplierEntity params) async {
    return await repository.addSupplier(params);
  }
}
