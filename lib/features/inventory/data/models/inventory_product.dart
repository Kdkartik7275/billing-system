import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:hive/hive.dart';

part 'inventory_product.g.dart';

@HiveType(typeId: 0)
class InventoryProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sku;

  @HiveField(3)
  final String barcode;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final int stock;

  @HiveField(7)
  final String stockUnit;

  @HiveField(8)
  final String supplier;

  @HiveField(9)
  final String imageUrl;

  @HiveField(10)
  final double purchasePrice;

  InventoryProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.price,
    required this.stock,
    required this.stockUnit,
    required this.supplier,
    required this.imageUrl,
    required this.purchasePrice,
  });

  InventoryProduct toEntity() {
    return InventoryProduct(
      id: id,
      name: name,
      sku: sku,
      barcode: barcode,
      category: category,
      price: price,
      stock: stock,
      stockUnit: stockUnit,
      supplier: supplier,
      imageUrl: imageUrl,
      purchasePrice: purchasePrice,
    );
  }

  factory InventoryProductModel.fromEntity(InventoryProduct entity) {
    return InventoryProductModel(
      id: entity.id,
      name: entity.name,
      sku: entity.sku,
      barcode: entity.barcode,
      category: entity.category,
      price: entity.price,
      purchasePrice: entity.purchasePrice,
      stock: entity.stock,
      stockUnit: entity.stockUnit,
      supplier: entity.supplier,
      imageUrl: entity.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'category': category,
      'price': price,
      'purchasePrice': purchasePrice,
      'stock': stock,
      'stockUnit': stockUnit,
      'supplier': supplier,
      'imageUrl': imageUrl,
    };
  }

  factory InventoryProductModel.fromMap(Map<String, dynamic> map) {
    return InventoryProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      barcode: map['barcode'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      stockUnit: map['stockUnit'] ?? '',
      supplier: map['supplier'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  InventoryProductModel copyWith({
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
    return InventoryProductModel(
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
}
