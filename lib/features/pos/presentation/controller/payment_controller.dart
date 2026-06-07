import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/pos/data/models/payment_result.dart';
import 'package:billing_system/features/pos/domain/usecases/save_bill_usecase.dart';
import 'package:billing_system/features/pos/presentation/controller/bills_controller.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  final SaveBill saveBillUsecase;
  final CartController _cart = Get.find<CartController>();
  final InventoryController _inventory = Get.find<InventoryController>();
  final _billController = Get.find<BillsController>();

  final Rx<PaymentMethod> selectedMethod = PaymentMethod.cash.obs;
  final RxString tenderedInput = ''.obs;
  final RxBool processing = false.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController tenderedController = TextEditingController();

  PaymentController({required this.saveBillUsecase});

  double get grandTotal => _cart.grandTotal;
  double get subtotal => _cart.subtotal;
  double get tax => _cart.tax;

  double get tendered => double.tryParse(tenderedInput.value) ?? 0;

  double get change {
    if (selectedMethod.value != PaymentMethod.cash) return 0;
    final c = tendered - grandTotal;
    return c < 0 ? 0 : c;
  }

  bool get cashIsValid =>
      selectedMethod.value == PaymentMethod.cash && tendered >= grandTotal;

  bool get canConfirm =>
      selectedMethod.value == PaymentMethod.card || cashIsValid;

  void selectMethod(PaymentMethod method) {
    selectedMethod.value = method;
    errorMessage.value = '';
  }

  void updateTendered(String value) {
    tenderedInput.value = value;
    errorMessage.value = '';
  }

  void setExactAmount() {
    final exact = grandTotal.toStringAsFixed(2);
    tenderedController.text = exact;
    tenderedInput.value = exact;
  }

  PaymentResult? confirmPayment() {
    if (!canConfirm) {
      errorMessage.value = 'Amount tendered is less than total';
      return null;
    }

    final result = PaymentResult(
      items: List.from(_cart.cartItems),
      subtotal: subtotal,
      tax: tax,
      grandTotal: grandTotal,
      method: selectedMethod.value,
      amountTendered: selectedMethod.value == PaymentMethod.cash
          ? tendered
          : grandTotal,
      change: change,
      paidAt: DateTime.now(),
      receiptNumber: _generateReceiptNumber(),
    );

    _deductStock();

    return result;
  }

  Future<void> saveBill(PaymentResult result) async {
    processing.value = true;

    try {
      final billData = {
        'id': Uuid().v4(),
        'receiptNumber': result.receiptNumber,
        'createdAt': result.paidAt.toIso8601String(),
        'customerName': 'Walk-in Customer',
        'customerPhone': '',

        'items': result.items
            .map(
              (item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'unitPrice': item.product.price,
                'totalPrice': item.total,
                'sku': item.product.sku,
              },
            )
            .toList(),
        'subtotal': result.subtotal,
        'paymentMethod': result.method.name,
        'amountTendered': result.amountTendered,
        'changeGiven': result.change,
        'createdBy': 'System',
        'taxRate': 5.0,
        'taxAmount': result.tax,
        'grandTotal': result.grandTotal,
        'status': 'completed',
      };
      debugPrint('Saving bill with data: $billData');
      final r = await saveBillUsecase.call(billData);
      _billController.getBills();
      r.fold((err) => AppSnackbar.error(message: err.message), (s) {});
    } catch (e) {
      AppSnackbar.error(message: 'Failed to save bill: $e');
      debugPrint('Error saving bill: $e');
    } finally {
      processing.value = false;
    }
  }

  Future<void> _deductStock() async {
    for (final cartItem in _cart.cartItems) {
      final idx = _inventory.products.indexWhere(
        (p) => p.id == cartItem.product.id,
      );
      if (idx == -1) continue;

      final current = _inventory.products[idx];
      final newStock = (current.stock - cartItem.quantity).clamp(0, 999999);
      await _inventory.updateProduct(current.copywith(stock: newStock));
    }
  }

  String _generateReceiptNumber() {
    final now = DateTime.now();
    return 'INV-'
        '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '-${now.millisecondsSinceEpoch % 100000}';
  }

  void reset() {
    selectedMethod.value = PaymentMethod.cash;
    tenderedInput.value = '';
    tenderedController.clear();
    errorMessage.value = '';
    processing.value = false;
  }
}
