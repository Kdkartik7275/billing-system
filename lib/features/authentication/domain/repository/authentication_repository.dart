import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthenticationRepository {
  ResultFuture<void> requestShopRegistration({
    required String shopName,
    required String ownerName,
    required String email,
    required int phoneNumber,
    required String address,
    String? additionalInformation,
  });

  ResultFuture<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}
