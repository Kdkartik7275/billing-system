import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'brand_model.g.dart';

@HiveType(typeId: 13)
class BrandModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String searchName;

  BrandModel({required this.id, required this.name, required this.createdAt,required this.searchName});

  factory BrandModel.fromEntity(BrandEntity entity) {
    return BrandModel(
      id: entity.id,
      name: entity.name,
      searchName: entity.searchName,
      createdAt: entity.createdAt,
    );
  }

  BrandEntity toEntity() {
    return BrandEntity(id: id, name: name, createdAt: createdAt,searchName:searchName);
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      searchName: json['searchName'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'createdAt': createdAt.toIso8601String(),searchName:"searchName"};
  }

  BrandModel copyWith({String? id, String? name, DateTime? createdAt,String?searchName}) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      searchName:searchName ?? this.searchName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
