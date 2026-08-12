import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/unit_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/unit_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/unit_repository.dart';
import 'package:fpdart/fpdart.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitRemoteDataSource remoteDataSource;
  final UnitLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  UnitRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<UnitEntity> addUnit(UnitEntity unit) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(message: 'No Internet Connection'),
        );
      }

      final model = UnitModel.fromEntity(unit);

      final result = await remoteDataSource.addUnit(model);

      await localDataSource.addUnit(result);

      return right(result.toEntity());
    } catch (e) {
      return left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  @override
  ResultFuture<List<UnitEntity>> getAllUnits() async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteUnits = await remoteDataSource.getAllUnits();

        // Replace local cache with latest remote data
        await localDataSource.clear();

        for (final unit in remoteUnits) {
          await localDataSource.addUnit(unit);
        }

        return right(
          remoteUnits.map((e) => e.toEntity()).toList(),
        );
      }

      // Offline → get from local cache
      final localUnits = await localDataSource.getAllUnits();

      return right(
        localUnits.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      // Remote failed → fallback to local cache
      try {
        final localUnits = await localDataSource.getAllUnits();

        return right(
          localUnits.map((e) => e.toEntity()).toList(),
        );
      } catch (_) {
        return left(
          FirebaseFailure(message: e.toString()),
        );
      }
    }
  }

  @override
  ResultFuture<UnitEntity?> getUnitById(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getUnitById(id);

        if (remote != null) {
          await localDataSource.updateUnit(remote);
        }

        return right(remote?.toEntity());
      }

      // Offline → local cache
      final local = await localDataSource.getUnitById(id);

      return right(local?.toEntity());
    } catch (e) {
      // Remote failed → fallback to local
      try {
        final local = await localDataSource.getUnitById(id);

        return right(local?.toEntity());
      } catch (_) {
        return left(
          FirebaseFailure(message: e.toString()),
        );
      }
    }
  }

  @override
  ResultFuture<UnitEntity> updateUnit(UnitEntity unit) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(message: 'No Internet Connection'),
        );
      }

      final model = UnitModel.fromEntity(unit);

      final updated = await remoteDataSource.updateUnit(model);

      await localDataSource.updateUnit(updated);

      return right(updated.toEntity());
    } catch (e) {
      return left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  @override
  ResultFuture<void> deleteUnit(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
          FirebaseFailure(message: 'No Internet Connection'),
        );
      }

      await remoteDataSource.deleteUnit(id);

      await localDataSource.deleteUnit(id);

      return const Right(null);
    } catch (e) {
      return left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }
}