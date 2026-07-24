import '../entities/stock_entity.dart';
import '../entities/stock_movement_entity.dart';
import '../repositories/stock_repository.dart';
import 'usecase.dart';

class AdjustStockParams {
  final String productId;
  final String warehouseId;
  final double quantityChange;
  final StockMovementType type;
  final String? reason;
  final String? referenceId;
  final String? performedByUserId;

  const AdjustStockParams({
    required this.productId,
    required this.warehouseId,
    required this.quantityChange,
    required this.type,
    this.reason,
    this.referenceId,
    this.performedByUserId,
  });
}

class AdjustStockUseCase
    implements UseCase<StockEntity, AdjustStockParams> {
  final StockRepository repository;

  const AdjustStockUseCase(this.repository);

  @override
  Future<StockEntity> call(AdjustStockParams params) {
    return repository.adjustStock(
      productId: params.productId,
      warehouseId: params.warehouseId,
      quantityChange: params.quantityChange,
      type: params.type,
      reason: params.reason,
      referenceId: params.referenceId,
      performedByUserId: params.performedByUserId,
    );
  }
}
