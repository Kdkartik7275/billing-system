import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/billing/domain/entities/customer_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'customer_model.g.dart';

@HiveType(typeId: HiveTypeIds.customerModel)
class CustomerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? phone;

  @HiveField(3)
  final String? email;

  CustomerModel({required this.id, required this.name, this.phone, this.email});

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(id: id, name: name, phone: phone, email: email);
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }

  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
