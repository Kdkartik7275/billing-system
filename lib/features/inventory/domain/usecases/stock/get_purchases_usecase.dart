import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class GetPurchasesUsecase
    implements UseCaseWithoutParams<List<PurchaseEntity>> {
  final StockRepository repository;

  GetPurchasesUsecase({required this.repository});
  @override
  ResultFuture<List<PurchaseEntity>> call() async {
    return await repository.getAllPurchases();
  }
}
