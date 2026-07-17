import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';

abstract interface class UserRepository {
  ResultFuture<UserEntity> getUserById(String userId);

  ResultFuture<ShopEntity> getShopById(String shopId);
}
