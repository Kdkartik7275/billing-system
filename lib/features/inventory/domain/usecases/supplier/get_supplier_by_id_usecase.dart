import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/supplier_repository.dart';

class GetSupplierByIdUsecase
    implements UseCaseWithParams<SupplierEntity?, String> {
  final SupplierRepository repository;

  GetSupplierByIdUsecase({required this.repository});
  @override
  ResultFuture<SupplierEntity?> call(String params) async {
    return await repository.getSupplierById(params);
  }
}
