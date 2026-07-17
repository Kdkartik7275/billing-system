import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/inventory_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/inventory_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final InventoryLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultVoid addProduct(InventoryProduct product) async {
    try {
      final model = InventoryProductModel(
        id: product.id,
        name: product.name,
        sku: product.sku,
        barcode: product.barcode,
        category: product.category,
        price: product.price,
        purchasePrice: product.purchasePrice,
        stock: product.stock,
        stockUnit: product.stockUnit,
        supplier: product.supplier,
        imageUrl: product.imageUrl,
      );

      final result = await remoteDataSource.addProduct(model);

      await localDataSource.addProduct(model);
      await localDataSource.addStockTransaction(
        // StockTransactionModel(
        //   id: model.id,
        //   productId: model.id,
        //   type: StockTransactionType.initialStock,
        //   previousStock: 0,
        //   quantityChanged: model.stock,
        //   newStock: model.stock,
        //   purchasePrice: model.price,
        //   referenceId: null,
        //   notes: 'Initial stock added',
        //   createdAt: DateTime.now(),
        // ),
        result.$2,
      );
      await localDataSource.addStockBatch(result.$1);

      return right(null);
    } catch (e) {
      debugPrint('Error adding product: $e');
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<InventoryProduct>> getProducts() async {
    try {
      final cachedProducts = await localDataSource.getCachedProducts();

      if (cachedProducts.isNotEmpty) {
        return right(cachedProducts.map((model) => model.toEntity()).toList());
      }

      final result = await remoteDataSource.getProducts();

      await localDataSource.cacheProducts(result.$1);
      await localDataSource.cacheStockBatches(result.$2);

      return right(result.$1.map((model) => model.toEntity()).toList());
    } catch (e) {
      final cachedProducts = await localDataSource.getCachedProducts();

      return right(cachedProducts.map((model) => model.toEntity()).toList());
    }
  }

  @override
  ResultFuture<InventoryProduct> updateProduct(InventoryProduct product) async {
    try {
      final model = InventoryProductModel(
        id: product.id,
        name: product.name,
        sku: product.sku,
        barcode: product.barcode,
        category: product.category,
        price: product.price,
        stock: product.stock,
        stockUnit: product.stockUnit,
        supplier: product.supplier,
        imageUrl: product.imageUrl,
        purchasePrice: product.purchasePrice,
      );

      if (!await connectionChecker.isConnected) {
        await localDataSource.updateProduct(model);
        return right(model.toEntity());
      }

      final updatedModel = await remoteDataSource.updateProduct(model);

      await localDataSource.updateProduct(updatedModel);

      return right(updatedModel.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid syncProducts(List<Map<String, dynamic>> productsData) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(
            message: 'No internet connection. Cannot sync products.',
          ),
        );
      }
      await remoteDataSource.syncProducts(productsData);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<InventoryProduct>> refreshProducts() async {
    try {
      final result = await remoteDataSource.refreshProducts();

      await localDataSource.cacheProducts(result.$1);
      await localDataSource.cacheStockBatches(result.$2);

      final cachedProducts = await localDataSource.getCachedProducts();

      return right(cachedProducts.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<StockTransaction>> getMovementLogs(String productId) async {
    try {
      if (!await connectionChecker.isConnected) {
        final movements = await localDataSource.getCachedMovements(productId);
        return right(movements.map((m) => m.toEntity()).toList());
      }

      final movements = await remoteDataSource.getMovementLogs(productId);
      return right(movements.map((m) => m.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<StockBatch>> getStockBatches(String productId) async {
    try {
      final batches = await localDataSource.getStockBatches(productId);

      return right(batches.map((b) => b.toEntity()).toList());
    } catch (e) {
      throw left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid purchaseStock({
    required int quantity,
    required int previousStock,
    required String productId,
    required double purchasePrice,
    required double sellingPrice,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(
            message: 'No internet connection. Cannot purchase stock.',
          ),
        );
      }

      final result = await remoteDataSource.purchaseStock(
        quantity: quantity,
        previousStock: previousStock,
        productId: productId,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
      );
      Future.wait([
        localDataSource.addStockTransaction(result.$2),
        localDataSource.addStockBatch(result.$1),
        localDataSource.updateProductStock(productId, previousStock + quantity),
      ]);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid sellStock({
    required int quantity,
    required int previousStock,
    required String productId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(
            message: 'No internet connection. Cannot sell stock.',
          ),
        );
      }

      final result = await remoteDataSource.sellStock(
        quantity: quantity,
        previousStock: previousStock,
        productId: productId,
      );

      Future.wait([
        localDataSource.addStockTransaction(result),
        localDataSource.updateProductStock(productId, previousStock - quantity),
      ]);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<InventoryProduct>> getProductsByIds(
    List<String> productIds,
  ) async {
    try {
      final cachedProducts = await localDataSource.getCachedProductsByIds(
        productIds,
      );

      return right(cachedProducts.map((model) => model.toEntity()).toList());
    } catch (e) {
      final cachedProducts = await localDataSource.getCachedProductsByIds(
        productIds,
      );

      return right(cachedProducts.map((model) => model.toEntity()).toList());
    }
  }
}
