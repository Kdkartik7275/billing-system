import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/stock_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/stock_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
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
  ResultFuture<List<StockEntity>> getAllStock() async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteStock = await remoteDataSource.getAllStock();

        await localDataSource.clear();

        for (final stock in remoteStock) {
          await localDataSource.createInitialStock(stock);
        }

        return right(remoteStock.map((e) => e.toEntity()).toList());
      }

      final localStock = await localDataSource.getAllStock();

      return right(localStock.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localStock = await localDataSource.getAllStock();

        return right(localStock.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<StockEntity?> getStockForProduct(
    String productId,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getStockForProduct(
          productId,
        );

        if (remote != null) {
          await localDataSource.createInitialStock(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getStockForProduct(
        productId,
      );

      return right(local?.toEntity());
    } catch (e) {
      try {
        final local = await localDataSource.getStockForProduct(
          productId,
        );

        return right(local?.toEntity());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
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
  ResultFuture<List<StockBatchEntity>> getAllStockBatches() async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getAllStockBatches();

        await localDataSource.clearStockBatches();

        for (final batch in remote) {
          await localDataSource.createStockBatch(batch);
        }

        return right(remote.map((e) => e.toEntity()).toList());
      }

      final local = await localDataSource.getAllStockBatches();

      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final local = await localDataSource.getAllStockBatches();

        return right(local.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<List<StockMovementEntity>> getAllStockMovements() async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getAllStockMovements();

        await localDataSource.clearStockMovements();

        for (final movement in remote) {
          await localDataSource.createStockMovement(movement);
        }

        return right(remote.map((e) => e.toEntity()).toList());
      }

      final local = await localDataSource.getAllStockMovements();

      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final local = await localDataSource.getAllStockMovements();

        return right(local.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<List<StockBatchEntity>> getStockBatchesForProduct(
    String productId,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getStockBatchesForProduct(
          productId,
        );

        await localDataSource.replaceStockBatchesForProduct(productId, remote);

        return right(remote.map((e) => e.toEntity()).toList());
      }

      final local = await localDataSource.getStockBatchesForProduct(productId);

      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final local = await localDataSource.getStockBatchesForProduct(
          productId,
        );

        return right(local.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<List<StockMovementEntity>> getStockMovementsForProduct(
    String productId,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getStockMovementsForProduct(
          productId,
        );

        await localDataSource.replaceStockMovementsForProduct(
          productId,
          remote,
        );

        return right(remote.map((e) => e.toEntity()).toList());
      }

      final local = await localDataSource.getStockMovementsForProduct(
        productId,
      );

      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final local = await localDataSource.getStockMovementsForProduct(
          productId,
        );

        return right(local.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
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

      // Update local cache
      await localDataSource.createInitialStock(result.stock);
      await localDataSource.createStockBatch(result.batch);
      await localDataSource.createStockMovement(result.movement);

      return right(null);
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
}
