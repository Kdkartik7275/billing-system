import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/stock_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/stock_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
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
    String warehouseId,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getStockForProduct(
          productId,
          warehouseId,
        );

        if (remote != null) {
          await localDataSource.createInitialStock(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getStockForProduct(
        productId,
        warehouseId,
      );

      return right(local?.toEntity());
    } catch (e) {
      try {
        final local = await localDataSource.getStockForProduct(
          productId,
          warehouseId,
        );

        return right(local?.toEntity());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }
}
