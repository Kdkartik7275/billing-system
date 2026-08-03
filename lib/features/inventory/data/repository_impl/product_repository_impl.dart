import 'dart:io';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/product_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/product_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<ProductEntity> addProduct(ProductEntity product) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = ProductModel.fromEntity(product);

      final result = await remoteDataSource.addProduct(model);

      await localDataSource.addProduct(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ProductEntity>> getAllProducts() async {
    try {
      final products = await _executeWithOfflineFallback<List<ProductModel>>(
        remoteCall: remoteDataSource.getAllProducts,
        localCall: localDataSource.getAllProducts,
        cacheData: (products) async {
          await localDataSource.clear();

          for (final product in products) {
            await localDataSource.addProduct(product);
          }
        },
      );

      return right(products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity?> getProductById(String id) async {
    try {
      final product = await _executeWithOfflineFallback<ProductModel?>(
        remoteCall: () => remoteDataSource.getProductById(id),
        localCall: () => localDataSource.getProductById(id),
        cacheData: (product) async {
          if (product != null) {
            await localDataSource.updateProduct(product);
          }
        },
      );

      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity?> getProductByBarcode(String barcode) async {
    try {
      final product = await _executeWithOfflineFallback<ProductModel?>(
        remoteCall: () => remoteDataSource.getProductByBarcode(barcode),
        localCall: () => localDataSource.getProductByBarcode(barcode),
        cacheData: (product) async {
          if (product != null) {
            await localDataSource.updateProduct(product);
          }
        },
      );

      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity?> getProductBySku(String sku) async {
    try {
      final product = await _executeWithOfflineFallback<ProductModel?>(
        remoteCall: () => remoteDataSource.getProductBySku(sku),
        localCall: () => localDataSource.getProductBySku(sku),
        cacheData: (product) async {
          if (product != null) {
            await localDataSource.updateProduct(product);
          }
        },
      );

      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ProductEntity>> searchProducts(String query) async {
    try {
      final products = await _executeWithOfflineFallback<List<ProductModel>>(
        remoteCall: () => remoteDataSource.searchProducts(query),
        localCall: () => localDataSource.searchProducts(query),
        cacheData: (products) async {
          for (final product in products) {
            await localDataSource.updateProduct(product);
          }
        },
      );

      return right(products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity> updateProduct(ProductEntity product) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = ProductModel.fromEntity(product);

      final updated = await remoteDataSource.updateProduct(model);

      await localDataSource.updateProduct(updated);

      return right(updated.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteProduct(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      await remoteDataSource.deleteProduct(id);

      await localDataSource.deleteProduct(id);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  Future<T> _executeWithOfflineFallback<T>({
    required Future<T> Function() remoteCall,
    required Future<T> Function() localCall,
    required Future<void> Function(T data) cacheData,
  }) async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteData = await remoteCall();

        await cacheData(remoteData);

        return remoteData;
      }

      return await localCall();
    } catch (_) {
      return await localCall();
    }
  }

  @override
  ResultFuture<List<String>> uploadProductImages(List<File> images) async {
    try {
      final imageUrls = await remoteDataSource.uploadProductImages(images);
      return right(imageUrls);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
