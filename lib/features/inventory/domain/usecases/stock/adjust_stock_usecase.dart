import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

enum AdjustmentDirection { increase, decrease }

class AdjustStockParams {
  final String productId;
  final String warehouseId;
  final AdjustmentDirection direction;
  final double quantity;
  final StockMovementType reasonType;
  final String? notes;

  const AdjustStockParams({
    required this.productId,
    required this.warehouseId,
    required this.direction,
    required this.quantity,
    required this.reasonType,
    this.notes,
  });
}

class AdjustStockUsecase implements UseCaseWithParams<void, AdjustStockParams> {
  final StockRepository repository;

  AdjustStockUsecase({required this.repository});

  @override
  ResultFuture<void> call(AdjustStockParams params) async {
    final stockResult = await repository.getStockForProduct(params.productId);

    return stockResult.fold(left, (currentStock) async {
      if (currentStock == null) {
        return left(
          FirebaseFailure(message: 'No stock record found for this product'),
        );
      }

      final delta = params.direction == AdjustmentDirection.increase
          ? params.quantity
          : -params.quantity;

      final newQuantity = currentStock.quantity + delta;

      if (newQuantity < 0) {
        return left(
          FirebaseFailure(message: 'Adjustment would result in negative stock'),
        );
      }

      final updatedStock = currentStock.copyWith(
        quantity: newQuantity,
        lastUpdated: DateTime.now(),
      );

      final updateResult = await repository.updateStock(updatedStock);

      return updateResult.fold(left, (_) async {
        final movement = StockMovementEntity(
          id: const Uuid().v4(),
          productId: params.productId,
          warehouseId: params.warehouseId,
          type: params.reasonType,
          quantityChange: delta,
          resultingQuantity: newQuantity,
          reason: params.notes,
          createdAt: DateTime.now(),
        );

        final movementResult = await repository.createStockMovement(movement);

        return movementResult.fold(left, (_) => right(null));
      });
    });
  }
}
