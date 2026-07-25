import 'package:billing_system/features/inventory/data/data_source/inventory_remote_data_source.dart';
import 'package:billing_system/features/inventory/data/models/inventory_product.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late InventoryRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    remoteDataSource = InventoryRemoteDataSourceImpl(firestore: firestore);
  });

  group('InventoryRemoteDataSource', () {
    final product = InventoryProductModel(
      id: '1',
      name: 'Apple',
      sku: 'SKU001',
      barcode: '123456',
      category: 'Fruits',
      price: 100,
      purchasePrice: 80,
      stock: 10,
      stockUnit: 'pcs',
      supplier: 'ABC Supplier',
      imageUrl: '',
    );

    test('should add product successfully', () async {
      // Act
      final result = await remoteDataSource.addProduct(product);

      // Assert
      expect(result.$1.productId, product.id);
      expect(result.$2.productId, product.id);

      final snapshot = await firestore
          .collection('products')
          .doc(product.id)
          .get();

      expect(snapshot.exists, true);
      expect(snapshot.data()!['name'], 'Apple');
      expect(snapshot.data()!['stock'], 10);
    });

    test('should update existing product', () async {
      // Arrange
      await firestore
          .collection('products')
          .doc(product.id)
          .set(product.toMap());

      final updatedProduct = InventoryProductModel(
        id: product.id,
        name: 'Updated Apple',
        sku: product.sku,
        barcode: product.barcode,
        category: product.category,
        price: 150,
        purchasePrice: 120,
        stock: 25,
        stockUnit: product.stockUnit,
        supplier: product.supplier,
        imageUrl: product.imageUrl,
      );

      // Act
      final result = await remoteDataSource.updateProduct(updatedProduct);

      // Assert
      expect(result.name, 'Updated Apple');

      final snapshot = await firestore
          .collection('products')
          .doc(product.id)
          .get();

      expect(snapshot.data()!['name'], 'Updated Apple');
      expect(snapshot.data()!['price'], 150);
      expect(snapshot.data()!['stock'], 25);
    });
  });
}
