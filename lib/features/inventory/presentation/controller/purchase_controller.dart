import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/purchase_stock_usecase.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPurchaseController extends GetxController {
  final ProductEntity product;
  final PurchaseStockUseCase purchaseStockUseCase;

  AddPurchaseController({
    required this.product,
    required this.purchaseStockUseCase,
  });

  // ---------------- TEXT CONTROLLERS ----------------
  final billInvoiceNoController = TextEditingController();
  final batchLotController = TextEditingController();
  final quantityController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final notesController = TextEditingController();

  // ---------------- REACTIVE FIELDS ----------------
  final Rx<String?> warehouseId = Rx<String?>(null);
  final Rx<DateTime> date = DateTime.now().obs;
  final Rx<String?> supplierId = Rx<String?>(null);
  final Rx<DateTime> billDate = DateTime.now().obs;
  final Rxn<DateTime> expiryDate = Rxn<DateTime>();
  final Rx<String?> paymentMethod = Rx<String?>(null);
  final Rxn<DateTime> dueDate = Rxn<DateTime>();

  final RxDouble quantity = 0.0.obs;
  final RxDouble purchasePrice = 0.0.obs;
  final RxDouble discountPercent = 0.0.obs;
  final RxDouble taxPercent = 0.0.obs;

  final InventoryController _inventoryController =
      Get.find<InventoryController>();

  List<String> get suppliers =>
      _inventoryController.suppliers.map((s) => s.name).toList();

  @override
  void onInit() {
    super.onInit();
    batchLotController.text = _generateBatchNumber(true);
    taxPercent.value = product.tax.gstPercent;
    purchasePriceController.text = product.price.purchasePrice.toStringAsFixed(
      2,
    );
    purchasePrice.value = product.price.purchasePrice;
  }

  String _generateBatchNumber(bool isPurchase) {
    final now = DateTime.now();
    return '${isPurchase ? 'PUR' : 'MAN'}-${now.year % 100}${now.month.toString().padLeft(2, '0')}-001';
  }

  // ---------------- FIELD HANDLERS ----------------
  void onQuantityChanged(String value) =>
      quantity.value = double.tryParse(value) ?? 0;
  void onPurchasePriceChanged(String value) =>
      purchasePrice.value = double.tryParse(value) ?? 0;
  void onDiscountChanged(String value) =>
      discountPercent.value = double.tryParse(value) ?? 0;
  void onTaxChanged(String value) =>
      taxPercent.value = double.tryParse(value) ?? 0;

  // ---------------- COMPUTED TOTALS ----------------
  double get subTotal => quantity.value * purchasePrice.value;
  double get discountAmount => subTotal * discountPercent.value / 100;
  double get taxableAmount => subTotal - discountAmount;
  double get taxAmount => taxableAmount * taxPercent.value / 100;
  double get totalAmount => taxableAmount + taxAmount;

  bool get isFormValid =>
      warehouseId.value != null &&
      supplierId.value != null &&
      billInvoiceNoController.text.trim().isNotEmpty &&
      quantity.value > 0 &&
      purchasePrice.value > 0;

  void savePurchase() async {
    if (!isFormValid) {
      AppSnackbar.error(message: 'Please fill all required fields');
      return;
    }
    String supplier = _inventoryController.suppliers
        .firstWhere((s) => s.name == supplierId.value)
        .id;
    final result = await purchaseStockUseCase.call(
      PurchaseStockParams(
        productId: product.id,
        warehouseId: warehouseId.value!,
        supplierId: supplier,

        notes: notesController.text.trim(),

        billDate: billDate.value,
        expiryDate: expiryDate.value,
        quantity: quantity.value.toInt(),
        price: purchasePrice.value,
        purchaseDate: DateTime.now(),
        invoiceNumber: billInvoiceNoController.text.trim(),
        batchNumber: batchLotController.text.trim(),
        tax: taxPercent.value,
        paymentMethod: paymentMethod.value ?? 'Cash',
        dueDate: dueDate.value ?? DateTime.now(),
      ),
    );

    result.fold((failure) => Get.snackbar('Error', failure.message), (success) {
      Get.back(result: true);
      AppSnackbar.success(message: 'Purchase recorded successfully.');
    });
  }

  @override
  void onClose() {
    billInvoiceNoController.dispose();
    batchLotController.dispose();
    quantityController.dispose();
    purchasePriceController.dispose();
    discountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
