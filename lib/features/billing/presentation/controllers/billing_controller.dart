import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_all_bills_usecase.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BillingController extends GetxController {
  final GetAllBillsUsecase getAllBillsUsecase;

  final RxString selectedCategory = 'All'.obs;
  final InventoryController inventoryController = Get.find();
  final RxList<BillEntity> bills = RxList<BillEntity>([]);

  @override
  void onInit() {
    super.onInit();
    getBills();
  }

  BillingController({required this.getAllBillsUsecase});
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

  Future<void> getBills() async {
    try {
      final result = await getAllBillsUsecase.call();
      result.fold((err) {}, (data) {
        bills.value = data;
        debugPrint("Bills: ${bills.length}");
      });
    } catch (e) {
      AppSnackbar.error(message: e.toString());
    }
  }
}
