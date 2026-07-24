import '../entities/product_entity.dart';

/// Contract for product persistence. Implemented by the data layer
/// (Hive locally, Firebase remotely) — the domain/presentation layers only
/// ever depend on this abstraction, never on a concrete datasource.
abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();

  Future<ProductEntity?> getProductById(String id);

  Future<ProductEntity?> getProductByBarcode(String barcode);

  Future<ProductEntity?> getProductBySku(String sku);

  Future<List<ProductEntity>> searchProducts(String query);

  Future<ProductEntity> addProduct(ProductEntity product);

  Future<ProductEntity> updateProduct(ProductEntity product);

  Future<void> deleteProduct(String id);

  /// Fires whenever the underlying product data set changes, so the
  /// presentation layer can keep an Rx list in sync without polling.
  Stream<List<ProductEntity>> watchProducts();
}
