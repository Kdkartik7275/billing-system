import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';

abstract interface class InventoryRepository {
  // Future<void> addProduct(Product product);

  ResultVoid addProduct(InventoryProduct product);

  ResultFuture<List<InventoryProduct>> getProducts();
  ResultFuture<List<InventoryProduct>> refreshProducts();

  ResultFuture<InventoryProduct> updateProduct(InventoryProduct product);

ResultVoid syncProducts(List<Map<String, dynamic>> productsData);
}
 