import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/domain/usecases/add_product_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DummyDart {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> seedProducts(List<InventoryProductModel> products) async {
    try {
      for (final product in products) {
        debugPrint("Uploading ${product.id}");
        final prod = product.toEntity();
        await AddProductUsecase(sl()).call(prod);
      }

      print(
        'Successfully added ${products.length} products and stock transactions',
      );
    } catch (e, stackTrace) {
      print('Error seeding products: $e');
      print(stackTrace);
    }
  }
}
