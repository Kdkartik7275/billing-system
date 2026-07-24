/// Represents a product category (e.g. Beverages, Dairy, Personal Care).
///
/// Categories are independent, top-level entities. A [ProductEntity]
/// references a category by [id] only — it never embeds this object,
/// so category renames/updates don't require touching product records.
class CategoryEntity {
  final String id;
  final String name;
  final String? description;
  final String? iconName;
  final bool isActive;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.isActive = true,
    required this.createdAt,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CategoryEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CategoryEntity(id: $id, name: $name)';
}
