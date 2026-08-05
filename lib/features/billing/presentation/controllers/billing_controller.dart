import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BillingController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final InventoryController inventoryController = Get.find();
  void selectCategory(String category) {
    debugPrint('Method called');
    selectedCategory.value = category;
  }

  List<ProductEntity> get filteredProducts {
    if (selectedCategory.value == 'All') {
      return inventoryController.products;
    }

    return inventoryController.products.where((product) {
      return product.categoryId == selectedCategory.value;
    }).toList();
  }
}
