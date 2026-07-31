import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class StockRemoteDataSource {
  Future<List<StockModel>> getAllStock();

  Future<StockModel?> getStockForProduct(String productId, String warehouseId);

  Future<StockModel> createInitialStock(StockModel stock);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final FirebaseFirestore firestore;

  const StockRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'stocks';

  @override
  Future<StockModel> createInitialStock(StockModel stock) async {
    try {
      await firestore.collection(_collection).doc(stock.id).set(stock.toJson());

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
      final snapshot = await firestore.collection(_collection).get();

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
          .collection(_collection)
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
}
