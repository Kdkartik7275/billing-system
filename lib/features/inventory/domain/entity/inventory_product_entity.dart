enum StockStatus { inStock, lowStock, outOfStock }

class InventoryProduct {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final double purchasePrice;
  final double price;
  final int stock;
  final String stockUnit;
  final String supplier;
  final String imageUrl;

  const InventoryProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.price,
    required this.purchasePrice,
    required this.stock,
    required this.stockUnit,
    required this.supplier,
    required this.imageUrl,
  });

  InventoryProduct copywith({
    String? id,
    String? name,
    String? sku,
    String? barcode,
    String? category,
    double? price,
    double? purchasePrice,
    int? stock,
    String? stockUnit,
    String? supplier,
    String? imageUrl,
  }) {
    return InventoryProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      price: price ?? this.price,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      stock: stock ?? this.stock,
      stockUnit: stockUnit ?? this.stockUnit,
      supplier: supplier ?? this.supplier,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  StockStatus get status {
    if (stock == 0) return StockStatus.outOfStock;
    if (stock < 20) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get totalValue => price * stock;
}
