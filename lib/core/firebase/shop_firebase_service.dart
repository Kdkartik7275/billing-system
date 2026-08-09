import 'dart:io';

import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class ShopFirebaseService {
  FirebaseApp? _app;
  FirebaseFirestore? _firestore;

  bool get isInitialized => _app != null && _firestore != null;

  Future<void> initialize(FirebaseConfigEntity config) async {
    try {
      if (_app != null) return;
      late final FirebaseOptions options;

      if (kIsWeb) {
        options = FirebaseOptions(
          apiKey: config.webApiKey,
          appId: config.webAppId,
          messagingSenderId: config.messagingSenderId,
          projectId: config.projectId,
          storageBucket: config.storageBucket,
          authDomain: config.authDomain,
        );
      } else if (Platform.isIOS) {
        options = FirebaseOptions(
          apiKey: config.iosApiKey,
          appId: config.iosAppId,
          messagingSenderId: config.messagingSenderId,
          projectId: config.projectId,
          storageBucket: config.storageBucket,
        );
      } else {
        options = FirebaseOptions(
          apiKey: config.androidApiKey,
          appId: config.androidAppId,
          messagingSenderId: config.messagingSenderId,
          projectId: config.projectId,
          storageBucket: config.storageBucket,
        );
      }

      _app = await Firebase.initializeApp(name: 'SHOP_APP', options: options);

      _firestore = FirebaseFirestore.instanceFor(app: _app!);

      debugPrint('Shop Firebase initialized successfully');
      debugPrint('Firebase App Name: ${_app!.name}');
      debugPrint('Firebase Project: ${_app!.options.projectId}');
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException [${e.code}] ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Error initializing Shop Firebase: $e');
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
