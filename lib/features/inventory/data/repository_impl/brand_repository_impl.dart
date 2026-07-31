import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/brand_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/brand_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';
import 'package:fpdart/fpdart.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;
  final BrandLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  const BrandRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<BrandEntity> addBrand(BrandEntity brand) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = BrandModel.fromEntity(brand);

      final created = await remoteDataSource.addBrand(model);

      await localDataSource.addBrand(created);

      return right(created.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<BrandEntity>> getAllBrands() async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteBrands = await remoteDataSource.getAllBrands();

        await localDataSource.clear();

        for (final brand in remoteBrands) {
          await localDataSource.addBrand(brand);
        }

        return right(remoteBrands.map((e) => e.toEntity()).toList());
      }

      final localBrands = await localDataSource.getAllBrands();

      return right(localBrands.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localBrands = await localDataSource.getAllBrands();

        return right(localBrands.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<BrandEntity?> getBrandById(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getBrandById(id);

        if (remote != null) {
          await localDataSource.updateBrand(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getBrandById(id);

      return right(local?.toEntity());
    } catch (e) {
      final local = await localDataSource.getBrandById(id);

      return right(local?.toEntity());
    }
  }

  @override
  ResultFuture<BrandEntity> updateBrand(BrandEntity brand) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = BrandModel.fromEntity(brand);

      final updated = await remoteDataSource.updateBrand(model);

      await localDataSource.updateBrand(updated);

      return right(updated.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> deleteBrand(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      await remoteDataSource.deleteBrand(id);

      await localDataSource.deleteBrand(id);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<BrandEntity?> getBrandByName(String name) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getBrandByName(name);

        if (remote != null) {
          await localDataSource.addBrand(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getBrandByName(name);

      return right(local?.toEntity());
    } catch (_) {
      final local = await localDataSource.getBrandByName(name);

      return right(local?.toEntity());
    }
  }
}
