import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_payment_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetPurchasePaymentsBySupplierUsecase
    implements UseCaseWithParams<List<PurchasePaymentEntity>, String> {
  final StockRepository repository;

  GetPurchasePaymentsBySupplierUsecase({required this.repository});
  @override
  ResultFuture<List<PurchasePaymentEntity>> call(String params) async {
    return await repository.getPurchasePaymentsBySupplier(params);
  }
}
