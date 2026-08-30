import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/stock_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/stock_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;
  final StockLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  StockRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  static const _refreshInterval = Duration(hours: 24);
  static const _historyWindow = Duration(days: 60);

  // ==========================================================
  // Writes — remote first, then local cache
  // ==========================================================

  @override
  ResultFuture<StockEntity> createInitialStock(StockEntity stock) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = StockModel.fromEntity(stock);

      final result = await remoteDataSource.createInitialStock(model);

      await localDataSource.createInitialStock(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StockBatchEntity> createStockBatch(
    StockBatchEntity batch,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.createStockBatch(
        StockBatchModel.fromEntity(batch),
      );

      await localDataSource.createStockBatch(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StockBatchEntity> updateStockBatch(
    StockBatchEntity batch,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = StockBatchModel.fromEntity(batch);

      final result = await remoteDataSource.updateStockBatch(model);

      await localDataSource.updateStockBatch(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StockMovementEntity> createStockMovement(
    StockMovementEntity movement,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.createStockMovement(
        StockMovementModel.fromEntity(movement),
      );

      await localDataSource.createStockMovement(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StockEntity> updateStock(StockEntity stock) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = StockModel.fromEntity(stock);

      final result = await remoteDataSource.updateStock(model);

      await localDataSource.updateStock(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
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
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.purchaseStock(
        productId: productId,
        warehouseId: warehouseId,
        supplierId: supplierId,
        quantity: quantity,
        price: price,
        purchaseDate: purchaseDate,
        invoiceNumber: invoiceNumber,
        billDate: billDate,
        batchNumber: batchNumber,
        expiryDate: expiryDate,
        discount: discount,
        tax: tax,
        paymentMethod: paymentMethod,
        dueDate: dueDate,
        notes: notes,
      );

      await localDataSource.createInitialStock(result.stock);
      await localDataSource.createStockBatch(result.batch);
      await localDataSource.createStockMovement(result.movement);
      await localDataSource.createPurchase(result.purchase);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.sellStock(
        productId: productId,
        warehouseId: warehouseId,
        quantity: quantity,
        price: price,
        saleDate: saleDate,
        discount: discount,
        tax: tax,
        paymentMethod: paymentMethod,
        reason: reason,
        referenceId: referenceId,
        notes: notes,
      );

      await localDataSource.updateStock(result.$1);

      for (final batch in result.$2) {
        await localDataSource.updateStockBatch(batch);
      }

      await localDataSource.createStockMovement(result.$3);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // Get all stock — once-daily (naturally bounded: 1 doc per product)
  // ==========================================================

  @override
  ResultFuture<List<StockEntity>> getAllStock() async {
    return _fetchAllOncePerDay<StockModel, StockEntity>(
      cacheKey: 'stock',
      remoteCall: remoteDataSource.getAllStock,
      localCall: localDataSource.getAllStock,
      replaceLocal: (items) async {
        await localDataSource.clear();
        for (final item in items) {
          await localDataSource.createInitialStock(item);
        }
      },
      toEntity: (m) => m.toEntity(),
    );
  }

  // ==========================================================
  // Get all batches / movements — LOCAL ONLY, never a global remote read
  // ==========================================================

  @override
  ResultFuture<List<StockBatchEntity>> getAllStockBatches() async {
    try {
      final local = await localDataSource.getAllStockBatches();
      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<StockMovementEntity>> getAllStockMovements() async {
    try {
      final local = await localDataSource.getAllStockMovements();
      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // Per-product batches / movements — once per product per day, 60-day window
  // ==========================================================

  @override
  ResultFuture<List<StockBatchEntity>> getStockBatchesForProduct(
    String productId,
  ) async {
    return _fetchProductScopedOncePerDay<StockBatchModel, StockBatchEntity>(
      cacheKey: 'batches_$productId',
      remoteCall: () => remoteDataSource.getStockBatchesForProductSince(
        productId,
        DateTime.now().subtract(_historyWindow),
      ),
      localCall: () => localDataSource.getStockBatchesForProduct(productId),
      replaceLocal: (items) =>
          localDataSource.replaceStockBatchesForProduct(productId, items),
      toEntity: (m) => m.toEntity(),
    );
  }

  @override
  ResultFuture<List<StockMovementEntity>> getStockMovementsForProduct(
    String productId,
  ) async {
    return await _fetchProductScopedOncePerDay<
      StockMovementModel,
      StockMovementEntity
    >(
      cacheKey: 'movements_$productId',
      remoteCall: () => remoteDataSource.getStockMovementsForProductSince(
        productId,
        DateTime.now().subtract(_historyWindow),
      ),
      localCall: () => localDataSource.getStockMovementsForProduct(productId),
      replaceLocal: (items) =>
          localDataSource.replaceStockMovementsForProduct(productId, items),
      toEntity: (m) => m.toEntity(),
    );
  }

  // ==========================================================
  // Per-product stock lookup — local only
  // ==========================================================

  @override
  ResultFuture<StockEntity?> getStockForProduct(String productId) async {
    try {
      final local = await localDataSource.getStockForProduct(productId);
      return right(local?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ==========================================================
  // Shared fetch-gate helpers
  // ==========================================================

  ResultFuture<List<E>> _fetchAllOncePerDay<M, E>({
    required String cacheKey,
    required Future<List<M>> Function() remoteCall,
    required Future<List<M>> Function() localCall,
    required Future<void> Function(List<M> items) replaceLocal,
    required E Function(M model) toEntity,
  }) async {
    try {
      final lastFetched = await localDataSource.getLastFetchedAt(cacheKey);
      final isStale =
          lastFetched == null ||
          DateTime.now().difference(lastFetched) >= _refreshInterval;

      if (!isStale) {
        final local = await localCall();
        return right(local.map(toEntity).toList());
      }

      if (await connectionChecker.isConnected) {
        try {
          final remoteItems = await remoteCall();
          await replaceLocal(remoteItems);
          await localDataSource.setLastFetchedAt(cacheKey, DateTime.now());

          return right(remoteItems.map(toEntity).toList());
        } catch (_) {
          final local = await localCall();
          return right(local.map(toEntity).toList());
        }
      }

      final local = await localCall();
      return right(local.map(toEntity).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  ResultFuture<List<E>> _fetchProductScopedOncePerDay<M, E>({
    required String cacheKey,
    required Future<List<M>> Function() remoteCall,
    required Future<List<M>> Function() localCall,
    required Future<void> Function(List<M> items) replaceLocal,
    required E Function(M model) toEntity,
  }) async {
    try {
      final lastFetched = await localDataSource.getLastFetchedAt(cacheKey);
      final isStale =
          lastFetched == null ||
          DateTime.now().difference(lastFetched) >= _refreshInterval;

      if (!isStale) {
        final local = await localCall();
        return right(local.map(toEntity).toList());
      }

      if (await connectionChecker.isConnected) {
        try {
          final remoteItems = await remoteCall();
          await replaceLocal(remoteItems);
          await localDataSource.setLastFetchedAt(cacheKey, DateTime.now());

          return right(remoteItems.map(toEntity).toList());
        } catch (e, stackTrace) {
          debugPrint('[$cacheKey] remote fetch failed: $e');
          debugPrint(stackTrace.toString());
          final local = await localCall();
          return right(local.map(toEntity).toList());
        }
      }

      final local = await localCall();
      return right(local.map(toEntity).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<PurchaseEntity>> getAllPurchases() async {
    try {
      final localPurchases = await localDataSource.getAllPurchases();

      if (localPurchases.isNotEmpty) {
        return right(
          localPurchases.map((purchase) => purchase.toEntity()).toList(),
        );
      }
      if (!await connectionChecker.isConnected) {
        return right([]);
      }
      final remotePurchases = await remoteDataSource.getAllPurchases();

      for (var purchase in remotePurchases) {
        await localDataSource.createPurchase(purchase);
      }
      return right(
        remotePurchases.map((purchase) => purchase.toEntity()).toList(),
      );
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<PurchaseEntity>> getPurchasesForProductSince(
    String productId,
    DateTime since,
  ) {
    // TODO: implement getPurchasesForProductSince
    throw UnimplementedError();
  }
}
