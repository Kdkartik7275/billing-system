import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

abstract interface class InventoryRemoteDataSource {
  Future<(StockBatchModel, StockTransactionModel)> addProduct(
    InventoryProductModel product,
  );
  Future<InventoryProductModel> updateProduct(InventoryProductModel product);
  Future<(List<InventoryProductModel>, List<StockBatchModel>)> getProducts();
  Future<(List<InventoryProductModel>, List<StockBatchModel>)>
  refreshProducts();
  Future<void> syncProducts(List<Map<String, dynamic>> productsData);
  Future<List<StockTransactionModel>> getMovementLogs(String productId);

  Future<(StockBatchModel, StockTransactionModel)> purchaseStock({
    required int quantity,
    required int previousStock,
    required String productId,
    required double purchasePrice,
    required double sellingPrice,
  });
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore firestore;

  InventoryRemoteDataSourceImpl({required this.firestore});
  @override
  Future<(StockBatchModel, StockTransactionModel)> addProduct(
    InventoryProductModel product,
  ) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .set(product.toMap());

      final stock = StockTransactionModel(
        id: Uuid().v4(),
        productId: product.id,
        type: StockTransactionType.initialStock,
        previousStock: 0,
        quantityChanged: product.stock,
        newStock: product.stock,

        referenceId: null,
        notes: 'Initial stock added',
        createdAt: DateTime.now(),
      );
      final StockBatchModel stockBatch = StockBatchModel(
        id: Uuid().v4(),
        productId: product.id,
        quantityRemaining: product.stock,
        purchasePrice: product.purchasePrice,
        sellingPrice: product.price,
        receivedDate: DateTime.now(),
      );

      await firestore
          .collection('stock_transactions')
          .doc(stock.id)
          .set(stock.toMap());
      await firestore
          .collection('stock_batch')
          .doc(stockBatch.id)
          .set(stockBatch.toMap());

      return (stockBatch, stock);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<(List<InventoryProductModel>, List<StockBatchModel>)>
  getProducts() async {
    try {
      final productsRef = await firestore.collection('products').get();
      final products = productsRef.docs
          .map((doc) => InventoryProductModel.fromMap(doc.data()))
          .toList();
      final stockBatchesRef = await firestore.collection('stock_batch').get();

      final stockBatches = stockBatchesRef.docs
          .map((doc) => StockBatchModel.fromMap(doc.data()))
          .toList();
      return (products, stockBatches);
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
  Future<(List<InventoryProductModel>, List<StockBatchModel>)>
  refreshProducts() async {
    try {
      final productsRef = await firestore.collection('products').get();
      final products = productsRef.docs
          .map((doc) => InventoryProductModel.fromMap(doc.data()))
          .toList();
      final stockBatchesRef = await firestore.collection('stock_batch').get();

      final stockBatches = stockBatchesRef.docs
          .map((doc) => StockBatchModel.fromMap(doc.data()))
          .toList();
      debugPrint("Stock batches length: ${stockBatches.length}");
      return (products, stockBatches);
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<List<StockTransactionModel>> getMovementLogs(String productId) async {
    try {
      final movementRef = await firestore
          .collection('stock_transactions')
          .where('productId', isEqualTo: productId)
          .get();
      return movementRef.docs
          .map((doc) => StockTransactionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<(StockBatchModel, StockTransactionModel)> purchaseStock({
    required int quantity,
    required int previousStock,
    required String productId,
    required double purchasePrice,
    required double sellingPrice,
  }) async {
    try {
      final stock = StockTransactionModel(
        id: Uuid().v4(),
        productId: productId,
        type: StockTransactionType.purchase,
        previousStock: previousStock,
        quantityChanged: quantity,
        newStock: previousStock + quantity,

        referenceId: null,
        notes: 'Purchased stock added',
        createdAt: DateTime.now(),
      );
      final StockBatchModel stockBatch = StockBatchModel(
        id: Uuid().v4(),
        productId: productId,
        quantityRemaining: quantity,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        receivedDate: DateTime.now(),
      );

      await firestore
          .collection('stock_transactions')
          .doc(stock.id)
          .set(stock.toMap());
      await firestore
          .collection('stock_batch')
          .doc(stockBatch.id)
          .set(stockBatch.toMap());
      await firestore.collection('products').doc(productId).update({
        'stock': FieldValue.increment(quantity),
      });
      return (stockBatch, stock);
    } catch (e) {
      throw Exception('Error Purchasing Stock');
    }
  }
}
