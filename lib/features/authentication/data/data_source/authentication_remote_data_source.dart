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
    final shopData = {
      "id": Uuid().v4(),
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
      switch (e.code) {
        case 'invalid-credential':
          throw Exception('Invalid email or password.');

        case 'wrong-password':
          throw Exception('Incorrect password. Please try again.');

        case 'user-not-found':
          throw Exception('No account found with this email address.');

        case 'invalid-email':
          throw Exception('Please enter a valid email address.');

        case 'user-disabled':
          throw Exception(
            'This account has been disabled. Please contact support.',
          );

        case 'too-many-requests':
          throw Exception('Too many failed attempts. Please try again later.');

        case 'network-request-failed':
          throw Exception(
            'Network error. Please check your internet connection.',
          );

        default:
          throw Exception('Unable to sign in. Please try again.');
      }
    } catch (e) {
      throw Exception('Unable to sign in. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw 'The password you entered is incorrect. Please try again.';
      } else if (e.code == 'weak-password') {
        throw 'Password must be at least 6 characters';
      } else {
        throw Exception(e.message ?? 'Auth error');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
