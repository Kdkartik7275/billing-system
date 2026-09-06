import 'package:billing_system/core/exceptions/firebase_auth_exceptions.dart';
import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<void> requestShopRegistration({
    required String shopName,
    required String ownerName,
    required String email,
    required int phoneNumber,
    required String address,
    String? additionalInformation,
  });
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future logout();
  Future<void> forgotPassword(String email);
  Future<void> changeUserPassword({
    required String oldPassword,
    required String newPassword,
  });
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final FirebaseFirestore firestore;

  AuthenticationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> requestShopRegistration({
    required String shopName,
    required String ownerName,
    required String email,
    required int phoneNumber,
    required String address,
    String? additionalInformation,
  }) async {
    try {
      final shopData = {
        "id": const Uuid().v4(),
        "shopName": shopName,
        "ownerName": ownerName,
        "email": email,
        "phone": phoneNumber.toString(),
        "address": address,
        "message": additionalInformation ?? "",
        "status": "pending",
        "createdAt": Timestamp.now(),
      };

      await firestore
          .collection('registration_requests')
          .doc(shopData["id"].toString())
          .set(shopData);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.requestShopRegistration',
      );
      throw Exception(TFirebaseException(e.code).message);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.requestShopRegistration',
      );
      rethrow;
    }
  }

  @override
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      await CrashlyticsService.log('Login failed: ${e.code}');
      throw Exception(TFirebaseAuthException(e.code).message);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.loginWithEmailAndPassword',
      );
      throw Exception('Unable to sign in. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.logout',
      );
      throw Exception(TFirebaseAuthException(e.code).message);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.logout',
      );
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.forgotPassword',
      );
      throw Exception(TFirebaseAuthException(e.code).message);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.forgotPassword',
      );
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> changeUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not logged in',
        );
      }

      if (newPassword.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'Password must be at least 6 characters',
        );
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.changeUserPassword',
      );
      throw Exception(TFirebaseAuthException(e.code).message);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'AuthenticationRemoteDataSourceImpl.changeUserPassword',
      );
      throw Exception('Something went wrong');
    }
  }
}
