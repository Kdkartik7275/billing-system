import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/features/authentication/data/data_source/authentication_remote_data_source.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

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
}
