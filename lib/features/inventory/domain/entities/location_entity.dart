/// A precise storage location (aisle / rack / shelf / bin) inside a
/// [WarehouseEntity]. Optional — small setups can leave stock unlocated,
/// but larger warehouses use this for pick-path optimization.
class LocationEntity {
  final String id;
  final String warehouseId;
  final String label;
  final String? aisle;
  final String? rack;
  final String? bin;
  final DateTime createdAt;

  const LocationEntity({
    required this.id,
    required this.warehouseId,
    required this.label,
    this.aisle,
    this.rack,
    this.bin,
    required this.createdAt,
  });

  LocationEntity copyWith({
    String? id,
    String? warehouseId,
    String? label,
    String? aisle,
    String? rack,
    String? bin,
    DateTime? createdAt,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      warehouseId: warehouseId ?? this.warehouseId,
      label: label ?? this.label,
      aisle: aisle ?? this.aisle,
      rack: rack ?? this.rack,
      bin: bin ?? this.bin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LocationEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LocationEntity(id: $id, label: $label)';
}
