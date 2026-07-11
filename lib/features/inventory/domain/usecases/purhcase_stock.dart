import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';

class PurhcaseStockUseCase
    implements UseCaseWithParams<void, PurhcaseStockParams> {
  final InventoryRepository repository;

  PurhcaseStockUseCase({required this.repository});
  @override
  ResultFuture<void> call(PurhcaseStockParams params) async {
    return await repository.purchaseStock(
      productId: params.productId,
      previousStock: params.previousStock,
      purchasePrice: params.purchasePrice,
      quantity: params.quantity,
      sellingPrice: params.sellingPrice,
    );
  }
}

class PurhcaseStockParams {
  final String productId;
  final int quantity;
  final int previousStock;
  final double purchasePrice;
  final double sellingPrice;

  PurhcaseStockParams({
    required this.productId,
    required this.quantity,
    required this.previousStock,
    required this.purchasePrice,
    required this.sellingPrice,
  });
}
