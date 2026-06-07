import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/inventory_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/inventory_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
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
        stock: product.stock,
        stockUnit: product.stockUnit,
        supplier: product.supplier,
        imageUrl: product.imageUrl,
      );

      await remoteDataSource.addProduct(model);

      await localDataSource.addProduct(model);
      await localDataSource.addStockTransaction(
        StockTransactionModel(
          id: model.id,
          productId: model.id,
          type: StockTransactionType.initialStock,
          previousStock: 0,
          quantityChanged: model.stock,
          newStock: model.stock,
          purchasePrice: model.price,
          referenceId: null,
          notes: 'Initial stock added',
          createdAt: DateTime.now(),
        ),
      );

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

      final remoteProducts = await remoteDataSource.getProducts();

      await localDataSource.cacheProducts(remoteProducts);

      return right(remoteProducts.map((model) => model.toEntity()).toList());
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
      final remoteProducts = await remoteDataSource.refreshProducts();

      await localDataSource.cacheProducts(remoteProducts);

      final cachedProducts = await localDataSource.getCachedProducts();

      return right(cachedProducts.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
