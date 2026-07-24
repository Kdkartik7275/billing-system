/// A physical or logical warehouse/store location where stock is held.
///
/// [StockEntity] records are scoped to a warehouse, which allows the same
/// product to have different stock levels across multiple outlets/godowns.
class WarehouseEntity {
  final String id;
  final String name;
  final String? address;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;

  const WarehouseEntity({
    required this.id,
    required this.name,
    this.address,
    this.isDefault = false,
    this.isActive = true,
    required this.createdAt,
  });

  WarehouseEntity copyWith({
    String? id,
    String? name,
    String? address,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return WarehouseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is WarehouseEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WarehouseEntity(id: $id, name: $name)';
}
