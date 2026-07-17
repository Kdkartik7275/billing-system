import 'dart:io';

import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class ShopFirebaseService {
  FirebaseApp? _app;
  FirebaseFirestore? _firestore;

  Future<void> initialize(FirebaseConfigEntity config) async {
    try {
      if (_app != null) return;

      final options = FirebaseOptions(
        apiKey: Platform.isIOS ? config.iosApiKey : config.androidApiKey,
        appId: Platform.isIOS ? config.iosAppId : config.androidAppId,
        messagingSenderId: config.messagingSenderId,
        projectId: config.projectId,
        storageBucket: config.storageBucket,
      );

      _app = await Firebase.initializeApp(name: "SHOP_APP", options: options);

      _firestore = FirebaseFirestore.instanceFor(app: _app!);

      debugPrint("Shop Firebase initialized successfully");
      debugPrint("Firebase App Name: ${_app!.name}");
      debugPrint("Firebase Project: ${_app!.options.projectId}");
    } on FirebaseException catch (e) {
      debugPrint("FirebaseException [${e.code}] ${e.message}");
      rethrow;
    } catch (e, stackTrace) {
      debugPrint("Error initializing Shop Firebase: $e");
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception("Shop Firebase not initialized");
    }
    return _firestore!;
  }

  Future<void> dispose() async {
    await _app?.delete();
    _app = null;
    _firestore = null;
  }
}
