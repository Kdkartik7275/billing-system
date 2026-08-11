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

  static const _refreshInterval = Duration(hours: 24);

  // ---------------- CREATE / UPDATE / DELETE — REMOTE FIRST, UNCHANGED ----------------

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

  // ---------------- GET ALL — ONCE-DAILY REMOTE FETCH, LOCAL OTHERWISE ----------------

  @override
  ResultFuture<List<ProductEntity>> getAllProducts() async {
    try {
      final lastFetched = await localDataSource.getLastFetchedAt();
      final isStale =
          lastFetched == null ||
          DateTime.now().difference(lastFetched) >= _refreshInterval;

      // Already fetched today — just serve local, no remote read at all.
      if (!isStale) {
        final local = await localDataSource.getAllProducts();
        return right(local.map((e) => e.toEntity()).toList());
      }

      // Stale or never fetched — try remote once, refresh local cache.
      if (await connectionChecker.isConnected) {
        try {
          final remoteProducts = await remoteDataSource.getAllProducts();

          await localDataSource.clear();
          for (final product in remoteProducts) {
            await localDataSource.addProduct(product);
          }
          await localDataSource.setLastFetchedAt(DateTime.now());

          return right(remoteProducts.map((e) => e.toEntity()).toList());
        } catch (_) {
          // Remote failed even though we're "online" — fall back to
          // whatever's already local rather than surfacing an error.
          final local = await localDataSource.getAllProducts();
          return right(local.map((e) => e.toEntity()).toList());
        }
      }

      // Offline and stale — best we can do is serve local anyway.
      final local = await localDataSource.getAllProducts();
      return right(local.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- LOOKUPS — LOCAL ONLY ----------------


  @override
  ResultFuture<ProductEntity?> getProductById(String id) async {
    try {
      final product = await localDataSource.getProductById(id);
      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity?> getProductByBarcode(String barcode) async {
    try {
      final product = await localDataSource.getProductByBarcode(barcode);
      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ProductEntity?> getProductBySku(String sku) async {
    try {
      final product = await localDataSource.getProductBySku(sku);
      return right(product?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ProductEntity>> searchProducts(String query) async {
    try {
      final products = await localDataSource.searchProducts(query);
      return right(products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  // ---------------- IMAGES — UNCHANGED ----------------

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
