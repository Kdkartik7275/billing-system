import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class InventoryRemoteDataSource {
  Future addProduct(InventoryProductModel product);
  Future<InventoryProductModel> updateProduct(InventoryProductModel product);
  Future<List<InventoryProductModel>> getProducts();
  Future<List<InventoryProductModel>> refreshProducts();
  Future<void> syncProducts(List<Map<String, dynamic>> productsData);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore firestore;

  InventoryRemoteDataSourceImpl({required this.firestore});
  @override
  Future<void> addProduct(InventoryProductModel product) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .set(product.toMap());

      final stock = StockTransactionModel(
        id: product.id,
        productId: product.id,
        type: StockTransactionType.initialStock,
        previousStock: 0,
        quantityChanged: product.stock,
        newStock: product.stock,
        purchasePrice: product.price,
        referenceId: null,
        notes: 'Initial stock added',
        createdAt: DateTime.now(),
      );

      await firestore.collection('stock_transactions').add(stock.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<List<InventoryProductModel>> getProducts() async {
    try {
      final productsRef = await firestore.collection('products').get();
      return productsRef.docs
          .map((doc) => InventoryProductModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<InventoryProductModel> updateProduct(
    InventoryProductModel product,
  ) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
      return product;
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> syncProducts(List<Map<String, dynamic>> productsData) async {
    try {
      final batch = firestore.batch();
      for (var productData in productsData) {
        final docRef = firestore.collection('products').doc(productData['id']);
        batch.set(docRef, {
          'stock': FieldValue.increment(-productData['quantity']),
        }, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to sync products: $e');
    }
  }

  @override
  Future<List<InventoryProductModel>> refreshProducts() async {
    try {
      final productsRef = await firestore.collection('products').get();
      return productsRef.docs
          .map((doc) => InventoryProductModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }
}
