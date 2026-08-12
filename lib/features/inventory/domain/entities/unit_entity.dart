class UnitEntity {
  final String id;
  final String name;
  final String shortName;
  final DateTime createdAt;

  const UnitEntity({
    required this.id,
    required this.name,
    required this.shortName,
    required this.createdAt,
  });

  UnitEntity copyWith({
    String? id,
    String? name,
    String? shortName,
    DateTime? createdAt,
  }) {
    return UnitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
