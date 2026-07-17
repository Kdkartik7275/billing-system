import 'package:hive/hive.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 21)
enum UserRole {
  @HiveField(0)
  owner,

  @HiveField(1)
  manager,

  @HiveField(2)
  cashier,
}

class UserEntity {
  final String uid;
  final String shopId;

  final String name;
  final String email;
  final String phone;

  final UserRole role;

  final bool isActive;

  final DateTime createdAt;
  final DateTime lastLogin;

  const UserEntity({
    required this.uid,
    required this.shopId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.lastLogin,
  });

  UserEntity copyWith({
    String? uid,
    String? shopId,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
