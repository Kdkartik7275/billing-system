class CustomerEntity {
  final String id;
  final String name;
  final String? phone;
  final String? email;

  const CustomerEntity({
    required this.id,
    required this.name,
    this.phone,
    this.email,
  });

  CustomerEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
