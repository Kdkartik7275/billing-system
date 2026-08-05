import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';

class DummyStockData {
  static List<StockBatchEntity> batches(
    String productId, {
    String warehouseId = 'wh_main',
  }) {
    final now = DateTime.now();

    return [
      StockBatchEntity(
        id: 'batch_1',
        productId: productId,
        warehouseId: warehouseId,
        batchNumber: 'BATCH-2405-001',
        quantity: 10,
        manufactureDate: now.subtract(const Duration(days: 90)),
        expiryDate: now.add(const Duration(days: 275)),
        purchasePrice: 125000,
        receivedAt: now.subtract(const Duration(days: 85)),
      ),
      StockBatchEntity(
        id: 'batch_2',
        productId: productId,
        warehouseId: warehouseId,
        batchNumber: 'BATCH-2405-002',
        quantity: 8,
        manufactureDate: now.subtract(const Duration(days: 88)),
        expiryDate: now.add(const Duration(days: 277)),
        purchasePrice: 124000,
        receivedAt: now.subtract(const Duration(days: 83)),
      ),
      StockBatchEntity(
        id: 'batch_3',
        productId: productId,
        warehouseId: warehouseId,
        batchNumber: 'BATCH-2405-003',
        quantity: 10,
        manufactureDate: now.subtract(const Duration(days: 82)),
        expiryDate: now.add(const Duration(days: 283)),
        purchasePrice: 126000,
        receivedAt: now.subtract(const Duration(days: 77)),
      ),
    ];
  }

  static List<StockMovementEntity> movements(
    String productId, {
    String warehouseId = 'wh_main',
  }) {
    final now = DateTime.now();

    return [
      StockMovementEntity(
        id: 'mv_1',
        productId: productId,
        warehouseId: warehouseId,
        batchId: 'batch_3',
        type: StockMovementType.purchaseIn,
        quantityChange: 10,
        resultingQuantity: 28,
        referenceId: 'PO-2024-0052',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      StockMovementEntity(
        id: 'mv_2',
        productId: productId,
        warehouseId: warehouseId,
        batchId: 'batch_2',
        type: StockMovementType.saleOut,
        quantityChange: -2,
        resultingQuantity: 18,
        referenceId: 'INV-2024-0126',
        createdAt: now.subtract(const Duration(days: 6)),
      ),
      StockMovementEntity(
        id: 'mv_3',
        productId: productId,
        warehouseId: warehouseId,
        batchId: 'batch_2',
        type: StockMovementType.purchaseIn,
        quantityChange: 8,
        resultingQuantity: 20,
        referenceId: 'PO-2024-0050',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      StockMovementEntity(
        id: 'mv_4',
        productId: productId,
        warehouseId: warehouseId,
        batchId: 'batch_1',
        type: StockMovementType.adjustment,
        quantityChange: 1,
        resultingQuantity: 12,
        reason: 'Recount correction',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      StockMovementEntity(
        id: 'mv_5',
        productId: productId,
        warehouseId: warehouseId,
        batchId: 'batch_1',
        type: StockMovementType.purchaseIn,
        quantityChange: 10,
        resultingQuantity: 10,
        referenceId: 'PO-2024-0048',
        createdAt: now.subtract(const Duration(days: 13)),
      ),
    ];
  }
}
