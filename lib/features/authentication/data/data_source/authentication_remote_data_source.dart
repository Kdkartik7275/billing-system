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
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
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
}
