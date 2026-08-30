import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/supplier_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/supplier_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/supplier_repository.dart';
import 'package:fpdart/fpdart.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource remoteDataSource;
  final SupplierLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  SupplierRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<SupplierEntity> addSupplier(SupplierEntity supplier) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = SupplierModel.fromEntity(supplier);

      final result = await remoteDataSource.addSupplier(model);

      // Keep local cache in sync with remote.
      await localDataSource.addSupplier(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<SupplierEntity>> getAllSuppliers() async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteSuppliers = await remoteDataSource.getAllSuppliers();

        // Refresh local cache.
        await localDataSource.clear();

        for (final supplier in remoteSuppliers) {
          await localDataSource.addSupplier(supplier);
        }

        return right(remoteSuppliers.map((e) => e.toEntity()).toList());
      }

      final localSuppliers = await localDataSource.getAllSuppliers();

      return right(localSuppliers.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localSuppliers = await localDataSource.getAllSuppliers();

        return right(localSuppliers.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<SupplierEntity?> getSupplierById(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getSupplierById(id);

        if (remote != null) {
          await localDataSource.updateSupplier(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getSupplierById(id);

      return right(local?.toEntity());
    } catch (e) {
      try {
        final local = await localDataSource.getSupplierById(id);

        return right(local?.toEntity());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<SupplierEntity> updateSupplier(SupplierEntity supplier) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = SupplierModel.fromEntity(supplier);

      final updated = await remoteDataSource.updateSupplier(model);

      await localDataSource.updateSupplier(updated);

      return right(updated.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> deleteSupplier(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      await remoteDataSource.deleteSupplier(id);

      await localDataSource.deleteSupplier(id);

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
