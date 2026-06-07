class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String imageUrl;
  final String barcode;
  final String sku;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.barcode,
    required this.sku,
  });
}