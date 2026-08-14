import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'unit_model.g.dart';

@HiveType(typeId: HiveTypeIds.unitModel)
class UnitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String shortName;

  @HiveField(3)
  final DateTime createdAt;

  UnitModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.createdAt,
  });

  /// Entity → Model
  factory UnitModel.fromEntity(UnitEntity entity) {
    return UnitModel(
      id: entity.id,
      name: entity.name,
      shortName: entity.shortName,
      createdAt: entity.createdAt,
    );
  }

  /// Model → Entity
  UnitEntity toEntity() {
    return UnitEntity(
      id: id,
      name: name,
      shortName: shortName,
      createdAt: createdAt,
    );
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'] as String,
      name: map['name'] as String,
      shortName: map['shortName'] as String,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'createdAt': createdAt,
    };
  }

  UnitModel copyWith({
    String? id,
    String? name,
    String? shortName,
    DateTime? createdAt,
  }) {
    return UnitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
