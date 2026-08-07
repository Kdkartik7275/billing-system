import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_summary_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/clear_cart_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/create_bill_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_next_bill_number_usecase.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

enum CheckoutStep { payment, receive }

enum PaymentMethodType { cash, card, upi, wallet, other }

extension PaymentMethodTypeX on PaymentMethodType {
  String get label {
    switch (this) {
      case PaymentMethodType.cash:
        return "Cash";
      case PaymentMethodType.card:
        return "Card";
      case PaymentMethodType.upi:
        return "UPI";
      case PaymentMethodType.wallet:
        return "Wallet";
      case PaymentMethodType.other:
        return "Other";
    }
  }

  String get subtitle {
    switch (this) {
      case PaymentMethodType.cash:
        return "Pay with cash";
      case PaymentMethodType.card:
        return "Debit / Credit Card";
      case PaymentMethodType.upi:
        return "Pay using UPI apps";
      case PaymentMethodType.wallet:
        return "Pay using wallet";
      case PaymentMethodType.other:
        return "Net Banking / Others";
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethodType.cash:
        return Icons.payments_outlined;
      case PaymentMethodType.card:
        return Icons.credit_card_outlined;
      case PaymentMethodType.upi:
        return Icons.qr_code_rounded;
      case PaymentMethodType.wallet:
        return Icons.account_balance_wallet_outlined;
      case PaymentMethodType.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PaymentMethodType.cash:
        return const Color(0xff2E7D32);
      case PaymentMethodType.card:
        return const Color(0xff1565C0);
      case PaymentMethodType.upi:
        return const Color(0xffEF6C00);
      case PaymentMethodType.wallet:
        return const Color(0xff6A1B9A);
      case PaymentMethodType.other:
        return Colors.grey.shade700;
    }
  }

  // ---------------- MAP TO DOMAIN ENUM ----------------
  PaymentMethod get toDomain {
    switch (this) {
      case PaymentMethodType.cash:
        return PaymentMethod.cash;
      case PaymentMethodType.card:
        return PaymentMethod.card;
      case PaymentMethodType.upi:
        return PaymentMethod.upi;
      case PaymentMethodType.wallet:
        return PaymentMethod.wallet;
      case PaymentMethodType.other:
        return PaymentMethod.other;
    }
  }
}

class CheckoutController extends GetxController {
  final CartController cartController;
  final CreateBillUsecase createBillUsecase;
  final GetNextBillNumberUsecase getNextBillNumberUsecase;
  final ClearCartUsecase clearCartUsecase;

  CheckoutController({
    required this.cartController,
    required this.createBillUsecase,
    required this.getNextBillNumberUsecase,
    required this.clearCartUsecase,
  });

  final Rx<CheckoutStep> step = CheckoutStep.payment.obs;
  final Rx<PaymentMethodType> selectedMethod = PaymentMethodType.cash.obs;
  final RxString customerName = 'Walk-in Customer'.obs;
  final RxDouble discount = 0.0.obs;
  final RxString amountReceived = ''.obs;
  final RxBool paymentSuccessful = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<BillEntity?> completedBill = Rx<BillEntity?>(null);

  // ---------------- TOTALS ----------------

  double get subtotal => cartController.subtotal;
  double get tax => cartController.totalTax;

  double get grandTotal {
    final total = subtotal + tax - discount.value;
    return total < 0 ? 0 : total;
  }

  double get amountReceivedValue => double.tryParse(amountReceived.value) ?? 0;

  double get changeToReturn {
    final change = amountReceivedValue - grandTotal;
    return change > 0 ? change : 0;
  }

  List<double> get quickAmounts {
    final total = grandTotal;
    final rounded100 = (total / 100).ceil() * 100.0;
    final options = <double>{
      total,
      rounded100,
      rounded100 + 500,
      rounded100 + 1000,
    }.toList();
    options.sort();
    return options.take(4).toList();
  }

  // ---------------- DISCOUNT ----------------

  void setDiscount(double value) {
    discount.value = value < 0 ? 0 : value;
  }

  // ---------------- CUSTOMER ----------------

  void setCustomerName(String name) {
    customerName.value = name.isEmpty ? 'Walk-in Customer' : name;
  }

  // ---------------- PAYMENT METHOD ----------------

  void selectPaymentMethod(PaymentMethodType type) {
    selectedMethod.value = type;
  }

  // ---------------- STEP NAVIGATION ----------------

  void goToReceivePayment() {
    step.value = CheckoutStep.payment == step.value
        ? CheckoutStep.receive
        : step.value;
    step.value = CheckoutStep.receive;
  }

  void backToPaymentMethod() {
    step.value = CheckoutStep.payment;
  }

  // ---------------- AMOUNT INPUT ----------------

  void selectQuickAmount(double amount) {
    amountReceived.value = amount.toStringAsFixed(
      amount.truncateToDouble() == amount ? 0 : 2,
    );
  }

  void appendDigit(String digit) {
    if (digit == '.' && amountReceived.value.contains('.')) return;
    if (amountReceived.value.contains('.')) {
      final decimals = amountReceived.value.split('.').last;
      if (decimals.length >= 2) return;
    }
    amountReceived.value += digit;
  }

  void backspace() {
    if (amountReceived.value.isEmpty) return;
    amountReceived.value = amountReceived.value.substring(
      0,
      amountReceived.value.length - 1,
    );
  }

  void clearAmount() {
    amountReceived.value = '';
  }

  // ---------------- CONFIRM / PERSIST BILL ----------------

  Future<void> confirmPayment() async {
    if (isProcessing.value) return;
    if (amountReceivedValue < grandTotal) return;

    isProcessing.value = true;
    errorMessage.value = '';

    final userController = Get.find<UserController>();
    final cashierId = userController.user.value?.uid ?? '';

    const uuid = Uuid();

    final billNumberResult = await getNextBillNumberUsecase();

    final result = await billNumberResult.fold(
      (failure) async {
        errorMessage.value = failure.message;
        return null;
      },
      (billNumber) async {
        final items = cartController.cartItems.values.map((cartItem) {
          final product = cartItem.product;
          final unitPrice = product.price.sellingPrice;
          final taxAmount =
              product.tax.taxAmountFor(unitPrice) * cartItem.quantity;
          final lineTotal = product.finalSellingPrice * cartItem.quantity;

          return BillItemEntity(
            id: uuid.v4(),
            productId: product.id,
            productName: product.name,
            sku: product.sku,
            barcode: product.barcode,
            quantity: cartItem.quantity.toDouble(),
            unitPrice: unitPrice,
            mrp: product.price.mrp ?? unitPrice,
            discount: 0,
            taxPercent: product.tax.gstPercent,
            tax: taxAmount,

            total: lineTotal,
          );
        }).toList();

        final payment = PaymentEntity(
          id: uuid.v4(),
          method: selectedMethod.value.toDomain,
          amount: amountReceivedValue,
          paidAt: DateTime.now(),
        );

        final paymentSummary = PaymentSummaryEntity(
          payments: [payment],
          paidAmount: amountReceivedValue,
          changeAmount: changeToReturn,
          pendingAmount: 0,
        );

        final bill = BillEntity(
          id: uuid.v4(),
          billNumber: billNumber,
          cashierId: cashierId,
          customer: null,
          items: items,
          subTotal: subtotal,
          discount: discount.value,
          tax: tax,
          grandTotal: grandTotal,
          payment: paymentSummary,
          status: BillStatus.completed,
          synced: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          warehouseId: '',
        );

        return bill;
      },
    );

    if (result == null) {
      isProcessing.value = false;
      return;
    }

    final createResult = await createBillUsecase.call(result);

    createResult.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (createdBill) {
        completedBill.value = createdBill;
        paymentSuccessful.value = true;
        cartController.clearCart();
        clearCartUsecase();
      },
    );

    isProcessing.value = false;
  }

  void resetCheckout() {
    step.value = CheckoutStep.payment;
    selectedMethod.value = PaymentMethodType.cash;
    discount.value = 0;
    amountReceived.value = '';
    paymentSuccessful.value = false;
    errorMessage.value = '';
    completedBill.value = null;
  }
}
