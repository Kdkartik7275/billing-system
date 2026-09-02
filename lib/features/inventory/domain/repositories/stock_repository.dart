import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import '../entities/stock_entity.dart';

/// One sold line of a bill, reduced to just what stock needs to know.
class SaleStockLine {
  final String productId;
  final double quantity;

  const SaleStockLine({required this.productId, required this.quantity});
}

/// Outcome of a single product's stock deduction.
class AppliedStockReduction {
  final String productId;
  final double newQuantity;

  const AppliedStockReduction({
    required this.productId,
    required this.newQuantity,
  });
}

abstract class StockRepository {
  // ------------- Stock Entity --------------
  ResultFuture<List<StockEntity>> getAllStock();

  ResultFuture<StockEntity?> getStockForProduct(String productId);

  ResultFuture<StockEntity> createInitialStock(StockEntity stock);

  ResultFuture<StockEntity> updateStock(StockEntity stock);

  // ------------- Stock Movement --------------
  ResultFuture<List<StockMovementEntity>> getAllStockMovements();
  ResultFuture<List<StockMovementEntity>> getStockMovementsForProduct(
    String productId,
  );
  ResultFuture<StockMovementEntity> createStockMovement(
    StockMovementEntity movement,
  );

  // ------------- Stock Batch --------------
  ResultFuture<List<StockBatchEntity>> getAllStockBatches();
  ResultFuture<List<StockBatchEntity>> getStockBatchesForProduct(
    String productId,
  );
  ResultFuture<StockBatchEntity> createStockBatch(StockBatchEntity batch);
  ResultFuture<StockBatchEntity> updateStockBatch(StockBatchEntity batch);

  // -------------- Purchase Stock --------------
  ResultFuture<void> purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
    required double paidAmount,
    required DateTime purchaseDate,
    required String invoiceNumber,
    required DateTime billDate,
    required String batchNumber,
    DateTime? expiryDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    required DateTime dueDate,
    String? notes,
  });

  // -------------- Sell Stock --------------
  ResultFuture<void> sellStock({
    required String productId,
    required String warehouseId,
    required int quantity,
    required double price,
    required DateTime saleDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    String? reason,
    String? referenceId,
    String? notes,
  });
  /// Deducts sold quantities from the **local** stock records and writes a
  /// `saleOut` movement per line, without touching the network.
  ///
  /// This is what runs at the moment a sale is confirmed: a POS has to keep
  /// selling with no connectivity, so the register's own copy of stock is
  /// the immediate source of truth and the remote copy is caught up later
  /// by [pushLocalStockToRemote]. Quantities are clamped at zero and
  /// products with no local stock record are skipped.
  ResultFuture<List<AppliedStockReduction>> applySaleLocally({
    required List<SaleStockLine> lines,
    required String warehouseId,
    required String billId,
    String? performedByUserId,
  });

  /// Uploads the current local quantity for each product so the remote copy
  /// matches the register. Used by the sync job after locally-applied sales
  /// have been pushed; deliberately absolute rather than a delta, because
  /// the local value already reflects every applied bill.
  ResultFuture<void> pushLocalStockToRemote(List<String> productIds);

  ResultFuture<List<PurchaseEntity>> getAllPurchases();

  ResultFuture<List<PurchaseEntity>> getPurchasesForProductSince(
    String productId,
    DateTime since,
  );
}
