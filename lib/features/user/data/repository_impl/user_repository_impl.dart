import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/features/user/data/data_source/user_local_data_source.dart';
import 'package:billing_system/features/user/data/data_source/user_remote_data_source.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/domain/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  ResultFuture<UserEntity> getUserById(String userId) async {
    try {
      final cachedUser = await localDataSource.getCachedUser(userId);
      if (cachedUser != null) {
        return right(cachedUser.toEntity());
      }
      final userModel = await remoteDataSource.getUser(userId);
      await localDataSource.saveUser(userModel);
      return right(userModel.toEntity());
    } catch (e) {
      debugPrint('Error in getUserById: $e');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ShopEntity> getShopById(String shopId) async {
    try {
      final cachedShop = await localDataSource.getCachedShop(shopId);
      if (cachedShop != null) {
        return right(cachedShop.toEntity());
      }
      final shopModel = await remoteDataSource.getShop(shopId);
      await localDataSource.saveShop(shopModel);
      return right(shopModel.toEntity());
    } catch (e) {
      debugPrint('Error in getShopById: $e');
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
