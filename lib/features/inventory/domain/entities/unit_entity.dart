/// A unit of measurement a product is sold/stocked in (e.g. Piece, Kg, Litre, Box).
///
/// [allowsDecimal] controls whether stock/quantity fields for products using
/// this unit should accept fractional values (e.g. 2.5 kg) or must be
/// whole numbers (e.g. 3 pcs).
class UnitEntity {
  final String id;
  final String name;
  final String shortCode;
  final bool allowsDecimal;
  final DateTime createdAt;

  const UnitEntity({
    required this.id,
    required this.name,
    required this.shortCode,
    this.allowsDecimal = false,
    required this.createdAt,
  });

  UnitEntity copyWith({
    String? id,
    String? name,
    String? shortCode,
    bool? allowsDecimal,
    DateTime? createdAt,
  }) {
    return UnitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      shortCode: shortCode ?? this.shortCode,
      allowsDecimal: allowsDecimal ?? this.allowsDecimal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UnitEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UnitEntity(id: $id, shortCode: $shortCode)';
}
