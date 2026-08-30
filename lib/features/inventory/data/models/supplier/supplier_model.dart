import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'supplier_model.g.dart';

@HiveType(typeId: HiveTypeIds.supplierModel)
class SupplierModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? contactPerson;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? gstNumber;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final DateTime createdAt;

  SupplierModel({
    required this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.gstNumber,
    this.isActive = true,
    required this.createdAt,
  });

  // ---------------------------------------------------------------------------
  // ENTITY → MODEL
  // ---------------------------------------------------------------------------

  factory SupplierModel.fromEntity(SupplierEntity entity) {
    return SupplierModel(
      id: entity.id,
      name: entity.name,
      contactPerson: entity.contactPerson,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      gstNumber: entity.gstNumber,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  // ---------------------------------------------------------------------------
  // MODEL → ENTITY
  // ---------------------------------------------------------------------------

  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      address: address,
      gstNumber: gstNumber,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  // ---------------------------------------------------------------------------
  // JSON → MODEL
  // ---------------------------------------------------------------------------

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contactPerson: json['contactPerson'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      gstNumber: json['gstNumber'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  // ---------------------------------------------------------------------------
  // MODEL → JSON
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'gstNumber': gstNumber,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ---------------------------------------------------------------------------
  // COPY WITH
  // ---------------------------------------------------------------------------

  SupplierModel copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? gstNumber,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
}
