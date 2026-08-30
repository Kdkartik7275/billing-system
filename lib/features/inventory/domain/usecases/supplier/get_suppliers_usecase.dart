import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/supplier_repository.dart';

class GetSuppliersUsecase
    implements UseCaseWithoutParams<List<SupplierEntity>> {
  final SupplierRepository repository;

  GetSuppliersUsecase({required this.repository});
  @override
  ResultFuture<List<SupplierEntity>> call() async {
    return await repository.getAllSuppliers();
  }
}
