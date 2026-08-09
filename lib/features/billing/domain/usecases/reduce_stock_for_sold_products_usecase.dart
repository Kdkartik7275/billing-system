import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/product_sales_aggregate.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:fpdart/fpdart.dart';

class StockReductionResult {
  final String productId;
  final double newQuantity;

  const StockReductionResult({
    required this.productId,
    required this.newQuantity,
  });
}

class ReduceStockForSoldProductsUsecase
    implements
        UseCaseWithParams<
          List<StockReductionResult>,
          List<ProductSalesAggregate>
        > {
  final StockRepository stockRepository;

  ReduceStockForSoldProductsUsecase({required this.stockRepository});

  @override
  ResultFuture<List<StockReductionResult>> call(
    List<ProductSalesAggregate> aggregates,
  ) async {
    final results = <StockReductionResult>[];

    for (final aggregate in aggregates) {
      final stockResult = await stockRepository.getStockForProduct(
        aggregate.product.id,
      );

      final currentStock = stockResult.fold((_) => null, (s) => s);
      if (currentStock == null) continue;

      final newQuantity = currentStock.quantity - aggregate.quantitySold;
      final clampedQuantity = newQuantity < 0 ? 0.0 : newQuantity;

      final updatedStock = currentStock.copyWith(
        quantity: clampedQuantity,
        lastUpdated: DateTime.now(),
      );

      final updateResult = await stockRepository.updateStock(updatedStock);

      updateResult.fold((_) {}, (_) {
        results.add(
          StockReductionResult(
            productId: aggregate.product.id,
            newQuantity: clampedQuantity,
          ),
        );
      });
    }

    return Right(results);
  }
}
