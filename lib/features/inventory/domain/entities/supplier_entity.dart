/// Represents a vendor/supplier that products are purchased from.
class SupplierEntity {
  final String id;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstNumber;
  final bool isActive;
  final DateTime createdAt;

  const SupplierEntity({
    required this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.gstNumber,
    this.isActive = true,
    required this.createdAt,
  });

  SupplierEntity copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? gstNumber,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return SupplierEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SupplierEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SupplierEntity(id: $id, name: $name)';
}
