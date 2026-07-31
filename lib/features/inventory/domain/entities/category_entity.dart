class CategoryEntity {
  final String id;
  final String name;

  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,

    required this.createdAt,
  });

  CategoryEntity copyWith({String? id, String? name, DateTime? createdAt}) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,

      createdAt: createdAt ?? this.createdAt,
    );
  }
}
