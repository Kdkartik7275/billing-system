import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class SellStockUseCase implements UseCaseWithParams<void, SellStockParams> {
  final InventoryRepository repository;

  SellStockUseCase({required this.repository});
  @override
  ResultFuture<void> call(SellStockParams params) async {
    return await repository.sellStock(
      productId: params.productId,
      previousStock: params.previousStock,
      quantity: params.quantity,
    );
  }
}

class SellStockParams {
  final String productId;
  final int quantity;
  final int previousStock;

  SellStockParams({
    required this.productId,
    required this.quantity,
    required this.previousStock,
  });
}
