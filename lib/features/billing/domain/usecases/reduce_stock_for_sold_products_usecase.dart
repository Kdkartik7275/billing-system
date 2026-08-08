import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/product_sales_aggregate.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReduceStockForSoldProductsUsecase
    implements UseCaseWithParams<void, List<ProductSalesAggregate>> {
  final StockRepository stockRepository;

  ReduceStockForSoldProductsUsecase({
    required this.stockRepository,
  });

  @override
  ResultFuture<void> call(List<ProductSalesAggregate> aggregates) async {
    for (final aggregate in aggregates) {
      final stockResult = await stockRepository.getStockForProduct(
        aggregate.product.id,
      );

      final currentStock = stockResult.fold((_) => null, (s) => s);
      if (currentStock == null) continue;

      final newQuantity = currentStock.quantity - aggregate.quantitySold;

      final updatedStock = currentStock.copyWith(
        quantity: newQuantity < 0 ? 0 : newQuantity,
        lastUpdated: DateTime.now(),
      );

      await stockRepository.updateStock(updatedStock);
    }

    return const Right(null);
  }
}
