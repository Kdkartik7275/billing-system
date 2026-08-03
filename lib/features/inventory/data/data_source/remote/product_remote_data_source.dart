import 'dart:io';

import 'package:billing_system/core/services/storage/storage_service.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel?> getProductById(String id);

  Future<ProductModel?> getProductByBarcode(String barcode);

  Future<ProductModel?> getProductBySku(String sku);

  Future<List<ProductModel>> searchProducts(String query);

  Future<ProductModel> addProduct(ProductModel product);

  Future<ProductModel> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);

  Future<List<String>> uploadProductImages(List<File> images);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'prods';

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      await firestore
          .collection(_collection)
          .doc(product.id)
          .set(product.toJson());

      return product;
    } on FirebaseException catch (e) {
      throw Exception('Failed to add product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return ProductModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return ProductModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<ProductModel?> getProductBySku(String sku) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('sku', isEqualTo: sku)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return ProductModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      if (query.trim().isEmpty) {
        return getAllProducts();
      }

      final snapshot = await firestore
          .collection(_collection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to search products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      await firestore
          .collection(_collection)
          .doc(product.id)
          .update(product.toJson());

      return product;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<List<String>> uploadProductImages(List<File> images) async {
    try {
      final storageService = StorageService();
      List<String> uploadedImageUrls = [];

      for (File image in images) {
        final imageUrl = await storageService.uploadFileData(image);
        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
        } else {
          throw Exception('Failed to upload image: ${image.path}');
        }
      }

      return uploadedImageUrls;
    } catch (e) {
      throw Exception('Failed to upload product images: $e');
    }
  }
}
