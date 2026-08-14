import 'package:billing_system/features/user/domain/entity/business_detail_entity.dart';

class ShopEntity {
  final String id;

  final String shopName;

  final String ownerUid;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;

  final String address;

  final bool isActive;

  final String plan;
  final DateTime? subscriptionExpiry;

  final FirebaseConfigEntity firebaseConfig;
  final BusinessDetailsEntity businessDetails;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ShopEntity({
    required this.id,
    required this.shopName,
    required this.ownerUid,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.address,
    required this.isActive,
    required this.plan,
    required this.subscriptionExpiry,
    required this.firebaseConfig,
    required this.createdAt,
    required this.updatedAt,
    required this.businessDetails,
  });
}

class FirebaseConfigEntity {
  final String androidApiKey;
  final String iosApiKey;
  final String webApiKey;

  final String androidAppId;
  final String iosAppId;
  final String webAppId;

  final String projectId;
  final String messagingSenderId;
  final String storageBucket;
  final String authDomain;
  const FirebaseConfigEntity({
    required this.androidApiKey,
    required this.iosApiKey,
    required this.webApiKey,

    required this.androidAppId,
    required this.iosAppId,
    required this.webAppId,

    required this.projectId,
    required this.messagingSenderId,
    required this.storageBucket,
    required this.authDomain,
  });
}
