import 'package:billing_system/core/config/constants/typedefs.dart';

import '../entities/product_entity.dart';

abstract class ProductRepository {
  ResultFuture<List<ProductEntity>> getAllProducts();

  ResultFuture<ProductEntity?> getProductById(String id);

  ResultFuture<ProductEntity?> getProductByBarcode(String barcode);

  ResultFuture<ProductEntity?> getProductBySku(String sku);

  ResultFuture<List<ProductEntity>> searchProducts(String query);

  ResultFuture<ProductEntity> addProduct(ProductEntity product);

  ResultFuture<ProductEntity> updateProduct(ProductEntity product);

  ResultVoid deleteProduct(String id);
}
