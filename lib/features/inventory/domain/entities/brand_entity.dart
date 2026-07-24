/// Represents a product brand/manufacturer (e.g. Nestle, P&amp;G, Coca-Cola).
class BrandEntity {
  final String id;
  final String name;
  final String? logoUrl;
  final String? country;
  final bool isActive;
  final DateTime createdAt;

  const BrandEntity({
    required this.id,
    required this.name,
    this.logoUrl,
    this.country,
    this.isActive = true,
    required this.createdAt,
  });

  BrandEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? country,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is BrandEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BrandEntity(id: $id, name: $name)';
}
