import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'UserRemoteDataSourceImpl.getUser',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'UserRemoteDataSourceImpl.getUser',
      );

      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'UserRemoteDataSourceImpl.getShop',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'UserRemoteDataSourceImpl.getShop',
      );
      throw TFirebaseException('unknown');
    }
  }
}
