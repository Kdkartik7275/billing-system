class ProductImage {
  final String url;
  final bool isPrimary;
  final String? altText;

  const ProductImage({required this.url, this.isPrimary = false, this.altText});

  ProductImage copyWith({String? url, bool? isPrimary, String? altText}) {
    return ProductImage(
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      altText: altText ?? this.altText,
    );
  }
}
