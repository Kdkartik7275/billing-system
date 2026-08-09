import 'package:billing_system/features/user/data/models/firebase_config_model.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'shop_model.g.dart';

@HiveType(typeId: 4)
class ShopModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String shopName;

  @HiveField(2)
  final String ownerUid;

  @HiveField(3)
  final String ownerName;

  @HiveField(4)
  final String ownerEmail;

  @HiveField(5)
  final String ownerPhone;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final String plan;

  @HiveField(9)
  final DateTime? subscriptionExpiry;

  @HiveField(10)
  final FirebaseConfigModel firebaseConfig;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  ShopModel({
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
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      shopName: json['shopName'],
      ownerUid: json['ownerUid'],
      ownerName: json['ownerName'],
      ownerEmail: json['ownerEmail'],
      ownerPhone: json['ownerPhone'],
      address: json['address'],
      isActive: json['isActive'] ?? true,
      plan: json['plan'] ?? 'Free',
      subscriptionExpiry: json['subscriptionExpiry'] != null
          ? (json['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      firebaseConfig: FirebaseConfigModel.fromJson(json['firebaseConfig']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'address': address,
      'isActive': isActive,
      'plan': plan,
      'subscriptionExpiry': subscriptionExpiry,
      'firebaseConfig': firebaseConfig.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ShopEntity toEntity() {
    return ShopEntity(
      id: id,
      shopName: shopName,
      ownerUid: ownerUid,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      address: address,
      isActive: isActive,
      plan: plan,
      subscriptionExpiry: subscriptionExpiry,
      firebaseConfig: firebaseConfig.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ShopModel.fromEntity(ShopEntity entity) {
    return ShopModel(
      id: entity.id,
      shopName: entity.shopName,
      ownerUid: entity.ownerUid,
      ownerName: entity.ownerName,
      ownerEmail: entity.ownerEmail,
      ownerPhone: entity.ownerPhone,
      address: entity.address,
      isActive: entity.isActive,
      plan: entity.plan,
      subscriptionExpiry: entity.subscriptionExpiry,
      firebaseConfig: FirebaseConfigModel.fromEntity(entity.firebaseConfig),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
