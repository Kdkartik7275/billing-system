/// A single image associated with a product. Embedded as a list inside
/// [ProductEntity] — products commonly have one primary image plus optional
/// gallery images, none of which need independent identity/repositories.
class ProductImage {
  final String url;
  final bool isPrimary;
  final String? altText;

  const ProductImage({
    required this.url,
    this.isPrimary = false,
    this.altText,
  });

  ProductImage copyWith({
    String? url,
    bool? isPrimary,
    String? altText,
  }) {
    return ProductImage(
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      altText: altText ?? this.altText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductImage &&
          other.url == url &&
          other.isPrimary == isPrimary &&
          other.altText == altText);

  @override
  int get hashCode => Object.hash(url, isPrimary, altText);

  @override
  String toString() => 'ProductImage(url: $url, isPrimary: $isPrimary)';
}
