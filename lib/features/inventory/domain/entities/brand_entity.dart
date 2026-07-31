/// Represents a product brand/manufacturer (e.g. Nestle, P&amp;G, Coca-Cola).
class BrandEntity {
  final String id;
  final String name;
  final String searchName;
  final DateTime createdAt;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.searchName,
    required this.createdAt,
  });

  BrandEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? searchName,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      searchName: searchName ?? this.searchName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
