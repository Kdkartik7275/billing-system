import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetSupplierPurchasesUsecase
    implements UseCaseWithParams<List<PurchaseEntity>, String> {
  final StockRepository repository;

  GetSupplierPurchasesUsecase({required this.repository});
  @override
  ResultFuture<List<PurchaseEntity>> call(String params) async {
    return await repository.getSupplierPurchases(params);
  }
}
