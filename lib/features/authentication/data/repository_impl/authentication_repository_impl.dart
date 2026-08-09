import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/features/authentication/data/data_source/authentication_remote_data_source.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<void> requestShopRegistration({
    required String shopName,
    required String ownerName,
    required String email,
    required int phoneNumber,
    required String address,
    String? additionalInformation,
  }) async {
    try {
      await remoteDataSource.requestShopRegistration(
        shopName: shopName,
        ownerName: ownerName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        additionalInformation: additionalInformation,
      );
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await remoteDataSource.logout();

      await Future.wait([
        sl<Box<ProductModel>>().clear(),
        sl<Box<CategoryModel>>().clear(),
        sl<Box<BrandModel>>().clear(),
        sl<Box<StockModel>>().clear(),
        sl<Box<StockBatchModel>>().clear(),
        sl<Box<StockMovementModel>>().clear(),
        sl<Box<UserModel>>().clear(),
        sl<Box<ShopModel>>().clear(),
        sl<Box>().clear(),
        sl<Box<BillModel>>().clear(),
        sl<Box<BillingCartModel>>().clear(),
      ]);

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
