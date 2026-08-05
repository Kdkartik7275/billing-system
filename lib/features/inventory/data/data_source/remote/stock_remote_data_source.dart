import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract interface class StockRemoteDataSource {
  // ==========================
  // Stock
  // ==========================

  Future<List<StockModel>> getAllStock();

  Future<StockModel?> getStockForProduct(String productId, String warehouseId);

  Future<StockModel> createInitialStock(StockModel stock);

  // ==========================
  // Stock Movement
  // ==========================

  Future<List<StockMovementModel>> getAllStockMovements();

  Future<List<StockMovementModel>> getStockMovementsForProduct(
    String productId,
  );

  Future<StockMovementModel> createStockMovement(StockMovementModel movement);

  // ==========================
  // Stock Batch
  // ==========================

  Future<List<StockBatchModel>> getAllStockBatches();

  Future<List<StockBatchModel>> getStockBatchesForProduct(String productId);

  Future<StockBatchModel> createStockBatch(StockBatchModel batch);

  Future<
    ({StockModel stock, StockBatchModel batch, StockMovementModel movement})
  >
  purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
    required DateTime purchaseDate,
    required String invoiceNumber,
    required DateTime billDate,
    required String batchNumber,
    DateTime? expiryDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    required DateTime dueDate,
    String? notes,
  });
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final FirebaseFirestore firestore;

  const StockRemoteDataSourceImpl({required this.firestore});

  static const _stockCollection = 'stocks';
  static const _movementCollection = 'stock_movements';
  static const _batchCollection = 'stock_batches';

  // ==========================================================
  // Stock
  // ==========================================================

  @override
  Future<StockModel> createInitialStock(StockModel stock) async {
    try {
      await firestore
          .collection(_stockCollection)
          .doc(stock.id)
          .set(stock.toJson());

      return stock;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create stock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create stock: $e');
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      final snapshot = await firestore.collection(_stockCollection).get();

      return snapshot.docs.map((e) => StockModel.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock: $e');
    }
  }

  @override
  Future<StockModel?> getStockForProduct(
    String productId,
    String warehouseId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_stockCollection)
          .where('productId', isEqualTo: productId)
          .where('warehouseId', isEqualTo: warehouseId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return StockModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock: $e');
    }
  }

  // ==========================================================
  // Stock Movement
  // ==========================================================

  @override
  Future<StockMovementModel> createStockMovement(
    StockMovementModel movement,
  ) async {
    try {
      await firestore
          .collection(_movementCollection)
          .doc(movement.id)
          .set(movement.toJson());

      return movement;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create stock movement: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create stock movement: $e');
    }
  }

  @override
  Future<List<StockMovementModel>> getAllStockMovements() async {
    try {
      final snapshot = await firestore
          .collection(_movementCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((e) => StockMovementModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock movements: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock movements: $e');
    }
  }

  @override
  Future<List<StockMovementModel>> getStockMovementsForProduct(
    String productId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_movementCollection)
          .where('productId', isEqualTo: productId)
          .get();

      return snapshot.docs
          .map((e) => StockMovementModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock movements: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock movements: $e');
    }
  }

  // ==========================================================
  // Stock Batch
  // ==========================================================

  @override
  Future<StockBatchModel> createStockBatch(StockBatchModel batch) async {
    try {
      await firestore
          .collection(_batchCollection)
          .doc(batch.id)
          .set(batch.toJson());

      return batch;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create stock batch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create stock batch: $e');
    }
  }

  @override
  Future<List<StockBatchModel>> getAllStockBatches() async {
    try {
      final snapshot = await firestore.collection(_batchCollection).get();

      return snapshot.docs
          .map((e) => StockBatchModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock batches: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock batches: $e');
    }
  }

  @override
  Future<List<StockBatchModel>> getStockBatchesForProduct(
    String productId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_batchCollection)
          .where('productId', isEqualTo: productId)
          .get();

      return snapshot.docs
          .map((e) => StockBatchModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch stock batches: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch stock batches: $e');
    }
  }

  @override
  Future<
    ({StockModel stock, StockBatchModel batch, StockMovementModel movement})
  >
  purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
    required DateTime purchaseDate,
    required String invoiceNumber,
    required DateTime billDate,
    required String batchNumber,
    DateTime? expiryDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    required DateTime dueDate,
    String? notes,
  }) async {
    try {
      late StockModel updatedStock;
      late StockBatchModel batch;
      late StockMovementModel movement;

      await firestore.runTransaction((transaction) async {
        final stockQuery = await firestore
            .collection(_stockCollection)
            .where('productId', isEqualTo: productId)
            .limit(1)
            .get();

        if (stockQuery.docs.isEmpty) {
          throw Exception('Stock record not found');
        }

        final stockDoc = stockQuery.docs.first;
        final stock = StockModel.fromJson(stockDoc.data());

        updatedStock = stock.copyWith(
          quantity: stock.quantity + quantity,
          lastUpdated: DateTime.now(),
        );

        transaction.update(stockDoc.reference, updatedStock.toJson());

        final batchRef = firestore.collection(_batchCollection).doc();

        batch = StockBatchModel(
          id: batchRef.id,
          productId: productId,
          warehouseId: warehouseId,
          batchNumber: batchNumber,
          quantity: quantity.toDouble(),
          manufactureDate: null,
          expiryDate: expiryDate,
          purchasePrice: price,
          receivedAt: purchaseDate,
        );

        transaction.set(batchRef, batch.toJson());

        final movementRef = firestore.collection(_movementCollection).doc();

        movement = StockMovementModel(
          id: Uuid().v4(),
          productId: productId,
          warehouseId: warehouseId,
          variantId: null,
          batchId: batch.id,
          type: StockMovementTypeModel.purchaseIn,
          quantityChange: quantity.toDouble(),
          resultingQuantity: updatedStock.quantity,
          reason: 'Purchase',
          referenceId: invoiceNumber,
          performedByUserId: null,
          createdAt: purchaseDate,
        );

        transaction.set(movementRef, movement.toJson());

        final purchaseRef = firestore.collection('purchases').doc();

        transaction.set(purchaseRef, {
          'id': purchaseRef.id,
          'productId': productId,
          'supplierId': supplierId,
          'warehouseId': warehouseId,
          'invoiceNumber': invoiceNumber,
          'purchaseDate': purchaseDate.toIso8601String(),
          'billDate': billDate.toIso8601String(),
          'quantity': quantity,
          'price': price,
          'discount': discount ?? 0,
          'tax': tax,
          'paymentMethod': paymentMethod,
          'dueDate': dueDate.toIso8601String(),
          'batchNumber': batchNumber,
          'notes': notes,
        });
      });

      return (stock: updatedStock, batch: batch, movement: movement);
    } on FirebaseException catch (e) {
      throw Exception('Failed to purchase stock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to purchase stock: $e');
    }
  }
}
