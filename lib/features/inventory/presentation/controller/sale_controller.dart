import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/sell_stock_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSaleController extends GetxController {
  final ProductEntity product;
  final SellStockUsecase sellStockUsecase;

  AddSaleController({required this.product, required this.sellStockUsecase});

  // ---------------- TEXT CONTROLLERS ----------------
  final quantityController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final reasonController = TextEditingController();
  final notesController = TextEditingController();

  // ---------------- REACTIVE FIELDS ----------------
  final Rx<String?> warehouseId = Rx<String?>(null);
  final Rx<DateTime> date = DateTime.now().obs;
  final Rx<String?> paymentMethod = Rx<String?>(null);

  final RxDouble quantity = 0.0.obs;
  final RxDouble sellingPrice = 0.0.obs;
  final RxDouble discountPercent = 0.0.obs;
  final RxDouble taxPercent = 0.0.obs;

  // ---------------- SAVE STATE ----------------
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    warehouseId.value = warehouses.first;
    taxPercent.value = product.tax.gstPercent;
    sellingPriceController.text = product.price.sellingPrice.toStringAsFixed(2);
    sellingPrice.value = product.price.sellingPrice;
  }

  // ---------------- FIELD HANDLERS ----------------
  void onQuantityChanged(String value) =>
      quantity.value = double.tryParse(value) ?? 0;
  void onSellingPriceChanged(String value) =>
      sellingPrice.value = double.tryParse(value) ?? 0;
  void onDiscountChanged(String value) =>
      discountPercent.value = double.tryParse(value) ?? 0;
  void onTaxChanged(String value) =>
      taxPercent.value = double.tryParse(value) ?? 0;

  // ---------------- COMPUTED TOTALS ----------------
  double get subTotal => quantity.value * sellingPrice.value;
  double get discountAmount => subTotal * discountPercent.value / 100;
  double get taxableAmount => subTotal - discountAmount;
  double get taxAmount => taxableAmount * taxPercent.value / 100;
  double get totalAmount => taxableAmount + taxAmount;

  bool get isFormValid =>
      warehouseId.value != null && quantity.value > 0 && sellingPrice.value > 0;

  void saveSale() async {
    if (isSaving.value) return;

    if (!isFormValid) {
      AppSnackbar.error(message: 'Please fill all required fields');
      return;
    }

    isSaving.value = true;

    final result = await sellStockUsecase.call(
      SellStockParams(
        productId: product.id,
        warehouseId: warehouseId.value!,
        quantity: quantity.value.toInt(),
        price: sellingPrice.value,
        saleDate: date.value,
        discount: discountPercent.value,
        tax: taxPercent.value,
        paymentMethod: paymentMethod.value ?? 'Cash',
        reason: reasonController.text.trim(),
        notes: notesController.text.trim(),
      ),
    );

    isSaving.value = false;

    result.fold((failure) => AppSnackbar.error(message: failure.message), (_) {
      AppSnackbar.success(message: 'Sale recorded successfully');
      Get.back(result: true);
    });
  }

  @override
  void onClose() {
    quantityController.dispose();
    sellingPriceController.dispose();
    discountController.dispose();
    reasonController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
