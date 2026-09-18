import 'dart:core';

import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_payment_model.dart';
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

  Future<StockModel?> getStockForProduct(String productId);

  Future<StockModel> createInitialStock(StockModel stock);

  Future<StockModel> updateStock(StockModel stock);

  // ==========================
  // Stock Movement
  // ==========================

  Future<List<StockMovementModel>> getAllStockMovements();

  Future<List<StockMovementModel>> getStockMovementsForProductSince(
    String productId,
    DateTime since,
  );

  Future<StockMovementModel> createStockMovement(StockMovementModel movement);

  // ==========================
  // Stock Batch
  // ==========================

  Future<List<StockBatchModel>> getAllStockBatches();

  Future<List<StockBatchModel>> getStockBatchesForProductSince(
    String productId,
    DateTime since,
  );

  Future<StockBatchModel> createStockBatch(StockBatchModel batch);

  Future<StockBatchModel> updateStockBatch(StockBatchModel batch);

  // ==========================
  // Purchase / Sell
  // ==========================

  Future<
    ({
      StockModel stock,
      StockBatchModel batch,
      StockMovementModel movement,
      PurchaseModel purchase,
    })
  >
  purchaseStock({
    required String productId,
    required String warehouseId,
    required String supplierId,
    required int quantity,
    required double price,
    required double paidAmount,
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

  Future<(StockModel, List<StockBatchModel>, StockMovementModel)> sellStock({
    required String productId,
    required String warehouseId,
    required int quantity,
    required double price,
    required DateTime saleDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    String? reason,
    String? referenceId,
    String? notes,
  });

  Future<List<PurchaseModel>> getAllPurchases();
  Future<List<PurchaseModel>> getSupplierPurchases(String supplierId);

  Future<List<PurchaseModel>> getPurchasesForProductSince(
    String productId,
    DateTime since,
  );

  Future<(PurchaseModel, PurchasePaymentModel)> makePurchasePayment({
    required String purchaseId,
    required double amount,
    required String paymentMethod,
    String? notes,
  });

  Future<List<PurchasePaymentModel>> getPurchasePaymentsBySupplier(
    String supplierId,
  );
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final FirebaseFirestore firestore;

  const StockRemoteDataSourceImpl({required this.firestore});

  static const _stockCollection = 'stocks';
  static const _movementCollection = 'stock_movements';
  static const _batchCollection = 'stock_batches';
  static const _purchaseCollection = 'purchases';
  static const _purchasePaymentCollection = 'purchase_payments';

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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createInitialStock',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createInitialStock',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      final snapshot = await firestore.collection(_stockCollection).get();

      return snapshot.docs.map((e) => StockModel.fromJson(e.data())).toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStock',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStock',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<StockModel?> getStockForProduct(String productId) async {
    try {
      final snapshot = await firestore
          .collection(_stockCollection)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return StockModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockForProduct',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockForProduct',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    try {
      await firestore
          .collection(_stockCollection)
          .doc(stock.id)
          .update(stock.toJson());

      return stock;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.updateStock',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.updateStock',
      );
      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createStockMovement',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createStockMovement',
      );
      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStockMovements',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStockMovements',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<StockMovementModel>> getStockMovementsForProductSince(
    String productId,
    DateTime since,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_movementCollection)
          .where('productId', isEqualTo: productId)
          .where('createdAt', isGreaterThanOrEqualTo: since.toIso8601String())
          .get();

      return snapshot.docs
          .map((e) => StockMovementModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockMovementsForProductSince',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockMovementsForProductSince',
      );
      throw TFirebaseException('unknown');
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
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createStockBatch',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.createStockBatch',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<StockBatchModel> updateStockBatch(StockBatchModel batch) async {
    try {
      await firestore
          .collection(_batchCollection)
          .doc(batch.id)
          .update(batch.toJson());

      return batch;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.updateStockBatch',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.updateStockBatch',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<StockBatchModel>> getAllStockBatches() async {
    try {
      final snapshot = await firestore.collection(_batchCollection).get();

      return snapshot.docs
          .map((e) => StockBatchModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStockBatches',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllStockBatches',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<StockBatchModel>> getStockBatchesForProductSince(
    String productId,
    DateTime since,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_batchCollection)
          .where('productId', isEqualTo: productId)
          .where('receivedAt', isGreaterThanOrEqualTo: since.toIso8601String())
          .get();

      return snapshot.docs
          .map((e) => StockBatchModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockBatchesForProductSince',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getStockBatchesForProductSince',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ==========================================================
  // Purchase
  // ==========================================================

  @override
  Future<
    ({
      StockModel stock,
      StockBatchModel batch,
      StockMovementModel movement,
      PurchaseModel purchase,
    })
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
    required double paidAmount,
    String? notes,
  }) async {
    try {
      late StockModel updatedStock;
      late StockBatchModel batch;
      late StockMovementModel movement;
      late PurchaseModel purchase;

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
          id: const Uuid().v4(),
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

        final purchaseRef = firestore.collection(_purchaseCollection).doc();

        purchase = PurchaseModel(
          id: purchaseRef.id,
          productId: productId,
          supplierId: supplierId,
          warehouseId: warehouseId,
          invoiceNumber: invoiceNumber,
          purchaseDate: purchaseDate,
          billDate: billDate,
          quantity: quantity,
          price: price,
          discount: discount ?? 0,
          tax: tax,
          paymentMethod: paymentMethod,
          dueDate: dueDate,
          batchNumber: batchNumber,
          notes: notes,
          paidAmount: paidAmount,
        );

        transaction.set(purchaseRef, purchase.toJson());
      });

      return (
        stock: updatedStock,
        batch: batch,
        movement: movement,
        purchase: purchase,
      );
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.purchaseStock',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.purchaseStock',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<PurchaseModel>> getAllPurchases() async {
    try {
      final snapshot = await firestore.collection(_purchaseCollection).get();

      return snapshot.docs
          .map((e) => PurchaseModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllPurchases',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllPurchases',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<PurchaseModel>> getPurchasesForProductSince(
    String productId,
    DateTime since,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_purchaseCollection)
          .where('productId', isEqualTo: productId)
          .where(
            'purchaseDate',
            isGreaterThanOrEqualTo: since.toIso8601String(),
          )
          .get();

      return snapshot.docs
          .map((e) => PurchaseModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getPurchasesForProductSince',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getPurchasesForProductSince',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ==========================================================
  // Sell
  // ==========================================================

  @override
  Future<(StockModel, List<StockBatchModel>, StockMovementModel)> sellStock({
    required String productId,
    required String warehouseId,
    required int quantity,
    required double price,
    required DateTime saleDate,
    double? discount,
    required double tax,
    required String paymentMethod,
    String? reason,
    String? referenceId,
    String? notes,
  }) async {
    try {
      late StockModel updatedStock;
      late List<StockBatchModel> updatedBatches;
      late StockMovementModel movement;

      await firestore.runTransaction((transaction) async {
        // ---------------- READS FIRST (Firestore transaction rule) ----------------
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

        if (stock.quantity < quantity) {
          throw Exception('Insufficient stock to complete this sale');
        }

        final batchQuery = await firestore
            .collection(_batchCollection)
            .where('productId', isEqualTo: productId)
            .get();

        final batches =
            batchQuery.docs
                .map((doc) => StockBatchModel.fromJson(doc.data()))
                .where((b) => b.quantity > 0)
                .toList()
              ..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));

        // ---------------- COMPUTE FIFO DEDUCTION ----------------
        double remaining = quantity.toDouble();
        final batchUpdates = <StockBatchModel>[];

        for (final batch in batches) {
          if (remaining <= 0) break;

          final deduct = remaining >= batch.quantity
              ? batch.quantity
              : remaining;

          batchUpdates.add(batch.copyWith(quantity: batch.quantity - deduct));

          remaining -= deduct;
        }

        // ---------------- WRITES ----------------
        updatedStock = stock.copyWith(
          quantity: stock.quantity - quantity,
          lastUpdated: DateTime.now(),
        );

        transaction.update(stockDoc.reference, updatedStock.toJson());

        for (final batch in batchUpdates) {
          transaction.update(
            firestore.collection(_batchCollection).doc(batch.id),
            batch.toJson(),
          );
        }

        updatedBatches = batchUpdates;

        final movementRef = firestore.collection(_movementCollection).doc();

        movement = StockMovementModel(
          id: movementRef.id,
          productId: productId,
          warehouseId: warehouseId,
          variantId: null,
          batchId: batchUpdates.isNotEmpty ? batchUpdates.first.id : null,
          type: StockMovementTypeModel.saleOut,
          quantityChange: -quantity.toDouble(),
          resultingQuantity: updatedStock.quantity,
          reason: reason ?? 'Manual sale',
          referenceId: referenceId,
          performedByUserId: null,
          createdAt: saleDate,
        );

        transaction.set(movementRef, movement.toJson());

        final saleRef = firestore.collection('sales').doc();

        transaction.set(saleRef, {
          'id': saleRef.id,
          'productId': productId,
          'warehouseId': warehouseId,
          'quantity': quantity,
          'price': price,
          'discount': discount ?? 0,
          'tax': tax,
          'paymentMethod': paymentMethod,
          'reason': reason,
          'referenceId': referenceId,
          'notes': notes,
          'saleDate': saleDate.toIso8601String(),
        });
      });

      return (updatedStock, updatedBatches, movement);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.sellStock',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.sellStock',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ==========================================================
  // Purchase Payment
  // ==========================================================

  @override
  Future<(PurchaseModel, PurchasePaymentModel)> makePurchasePayment({
    required String purchaseId,
    required double amount,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      late PurchaseModel updatedPurchase;
      late PurchasePaymentModel payment;

      await firestore.runTransaction((transaction) async {
        // ---------------- READ FIRST (Firestore transaction rule) ----------------
        final purchaseRef = firestore
            .collection(_purchaseCollection)
            .doc(purchaseId);

        final purchaseSnapshot = await transaction.get(purchaseRef);

        if (!purchaseSnapshot.exists) {
          throw Exception('Purchase not found');
        }

        final purchase = PurchaseModel.fromJson(purchaseSnapshot.data()!);

        // ---------------- VALIDATE ----------------
        if (amount <= 0) {
          throw Exception('Payment amount must be greater than zero');
        }

        final alreadyPaid = purchase.paidAmount ?? 0.0;
        final dueAmount = purchase.totalAmount - alreadyPaid;

        // Guard against floating point noise (e.g. 199.999999999998)
        // making a "pay in full" payment look like it slightly
        // overshoots the due amount.
        const epsilon = 0.01;
        if (amount > dueAmount + epsilon) {
          throw Exception(
            'Payment amount ($amount) exceeds the due amount '
            '($dueAmount) for this purchase',
          );
        }

        // ---------------- WRITES ----------------
        final newPaidAmount = alreadyPaid + amount;

        updatedPurchase = purchase.copyWith(paidAmount: newPaidAmount);

        transaction.update(purchaseRef, updatedPurchase.toJson());

        final paymentRef = firestore
            .collection(_purchasePaymentCollection)
            .doc();

        final now = DateTime.now();

        payment = PurchasePaymentModel(
          id: paymentRef.id,
          purchaseId: purchase.id,
          supplierId: purchase.supplierId,
          amount: amount,
          paymentDate: now,
          paymentMethod: paymentMethod,
          referenceNumber: null,
          notes: notes,
          createdAt: now,
        );

        transaction.set(paymentRef, payment.toJson());
      });

      return (updatedPurchase, payment);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.makePurchasePayment',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.makePurchasePayment',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<PurchasePaymentModel>> getPurchasePaymentsBySupplier(
    String supplierId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_purchasePaymentCollection)
          .where('supplierId', isEqualTo: supplierId)
          .orderBy('paymentDate', descending: true)
          .get();

      return snapshot.docs
          .map((e) => PurchasePaymentModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getPurchasePaymentsByPurchaseId',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getPurchasePaymentsByPurchaseId',
      );
      throw TFirebaseException('unknown');
    }
  }

  @override
  Future<List<PurchaseModel>> getSupplierPurchases(String supplierId) async {
    try {
      final snapshot = await firestore
          .collection(_purchaseCollection)
          .where('supplierId', isEqualTo: supplierId)
          .get();

      return snapshot.docs
          .map((e) => PurchaseModel.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllPurchases',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'StockRemoteDataSourceImpl.getAllPurchases',
      );
      throw TFirebaseException('unknown');
    }
  }
}
