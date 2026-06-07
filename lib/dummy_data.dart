import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DummyDart {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> seedProducts(List<InventoryProductModel> products) async {
    try {
      final batch = firestore.batch();

      for (final product in products) {
         print('Product ${product.id} Uploading');
        // Add Product
        final productRef = firestore.collection('products').doc(product.id);

        batch.set(productRef, product.toMap());

        // Add Initial Stock Transaction
        final stockRef = firestore.collection('stock_transactions').doc();

        final stock = StockTransactionModel(
          id: stockRef.id,
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

        batch.set(stockRef, stock.toMap());
      }

      await batch.commit();

      print('${products.length} products added successfully');
    } catch (e) {
      print('Error seeding products: $e');
    }
  }
}
