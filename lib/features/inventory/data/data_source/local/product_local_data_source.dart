import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel?> getProductById(String id);

  Future<ProductModel?> getProductByBarcode(String barcode);

  Future<ProductModel?> getProductBySku(String sku);

  Future<List<ProductModel>> searchProducts(String query);

  Future<ProductModel> addProduct(ProductModel product);

  Future<ProductModel> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);

  Future<void> clear();

  // ---------------- DAILY FETCH GATE ----------------
  Future<DateTime?> getLastFetchedAt();

  Future<void> setLastFetchedAt(DateTime time);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> box;
  final Box metaBox;

  const ProductLocalDataSourceImpl({required this.box, required this.metaBox});

  static const _lastFetchedKey = 'products_last_fetched_at';

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    await box.put(product.id, product);
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return box.values.toList();
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      return box.values.firstWhere((product) => product.barcode == barcode);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    return box.get(id);
  }

  @override
  Future<ProductModel?> getProductBySku(String sku) async {
    try {
      return box.values.firstWhere((product) => product.sku == sku);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase().trim();

    return box.values.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.sku.toLowerCase().contains(lowerQuery) ||
          product.barcode.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await box.put(product.id, product);
    return product;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  // ---------------- DAILY FETCH GATE ----------------

  @override
  Future<DateTime?> getLastFetchedAt() async {
    final raw = metaBox.get(_lastFetchedKey) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> setLastFetchedAt(DateTime time) async {
    await metaBox.put(_lastFetchedKey, time.toIso8601String());
  }
}
