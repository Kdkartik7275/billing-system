import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/inventory/data/data_source/local/category_local_data_source.dart';
import 'package:billing_system/features/inventory/data/data_source/remote/category_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<CategoryEntity> addCategory(CategoryEntity category) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = CategoryModel.fromEntity(category);

      final result = await remoteDataSource.addCategory(model);

      await localDataSource.addCategory(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CategoryEntity>> getAllCategories() async {
    try {
      if (await connectionChecker.isConnected) {
        final remoteCategories = await remoteDataSource.getAllCategories();

        await localDataSource.clear();

        for (final category in remoteCategories) {
          await localDataSource.addCategory(category);
        }

        return right(remoteCategories.map((e) => e.toEntity()).toList());
      }

      final localCategories = await localDataSource.getAllCategories();

      return right(localCategories.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localCategories = await localDataSource.getAllCategories();

        return right(localCategories.map((e) => e.toEntity()).toList());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<CategoryEntity?> getCategoryById(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getCategoryById(id);

        if (remote != null) {
          await localDataSource.updateCategory(remote);
        }

        return right(remote?.toEntity());
      }

      final local = await localDataSource.getCategoryById(id);

      return right(local?.toEntity());
    } catch (e) {
      try {
        final local = await localDataSource.getCategoryById(id);

        return right(local?.toEntity());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }

  @override
  ResultFuture<CategoryEntity> updateCategory(CategoryEntity category) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = CategoryModel.fromEntity(category);

      final updated = await remoteDataSource.updateCategory(model);

      await localDataSource.updateCategory(updated);

      return right(updated.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> deleteCategory(String id) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      await remoteDataSource.deleteCategory(id);
      await localDataSource.deleteCategory(id);

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
