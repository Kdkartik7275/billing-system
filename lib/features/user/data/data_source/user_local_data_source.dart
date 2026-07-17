import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract interface class UserLocalDataSource {
  Future<UserModel> saveUser(UserModel user);
  Future<UserModel?> getCachedUser(String userId);
  Future<void> deleteCachedUser(String userId);
  Future<ShopModel> saveShop(ShopModel shop);
  Future<ShopModel?> getCachedShop(String shopId);
  Future<void> deleteCachedShop(String shopId);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> userBox;
  final Box<ShopModel> shopBox;

  UserLocalDataSourceImpl({required this.userBox, required this.shopBox});

  @override
  Future<UserModel> saveUser(UserModel user) async {
    await userBox.put('current_user', user);
    return user;
  }

  @override
  Future<UserModel?> getCachedUser(String userId) async {
    return userBox.get(userId);
  }

  @override
  Future<void> deleteCachedUser(String userId) async {
    await userBox.delete(userId);
  }

  @override
  Future<ShopModel> saveShop(ShopModel shop) async {
    await shopBox.put('current_shop', shop);
    return shop;
  }

  @override
  Future<ShopModel?> getCachedShop(String shopId) async {
    return shopBox.get(shopId);
  }

  @override
  Future<void> deleteCachedShop(String shopId) async {
    await shopBox.delete(shopId);
  }
}
