import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);
  Future<ShopModel> getShop(String shopId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});
  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<ShopModel> getShop(String shopId) async {
    try {
      final shopDoc = await firestore.collection('shops').doc(shopId).get();
      if (!shopDoc.exists) {
        throw Exception('Shop not found');
      }
      return ShopModel.fromJson(shopDoc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch shop: $e');
    }
  }
}
