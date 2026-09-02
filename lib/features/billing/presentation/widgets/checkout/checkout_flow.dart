import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/billing/domain/usecases/apply_bill_stock_reduction_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/clear_cart_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/create_bill_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_next_bill_number_usecase.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/proceed_to_payment_view.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/receipt_dialog.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/receive_payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutFlow extends StatelessWidget {
  final CheckoutController checkoutController;
  final CartController cartController;
  final VoidCallback onEditCart;

  const CheckoutFlow({
    super.key,
    required this.checkoutController,
    required this.cartController,
    required this.onEditCart,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (checkoutController.step.value == CheckoutStep.payment) {
        return ProceedToPaymentView(
          checkoutController: checkoutController,
          cartController: cartController,
          onEditCart: onEditCart,
        );
      }

      return ReceivePaymentView(checkoutController: checkoutController);
    });
  }
}

// ---------------- DIALOG LAUNCHER ----------------

Future<void> showCheckoutFlow(
  BuildContext context, {
  required CartController cartController,
}) async {
  final checkoutController = Get.put(
    CheckoutController(
      cartController: cartController,
      createBillUsecase: sl<CreateBillUsecase>(),
      getNextBillNumberUsecase: sl<GetNextBillNumberUsecase>(),
      clearCartUsecase: sl<ClearCartUsecase>(),
      applyBillStockReductionUsecase: sl<ApplyBillStockReductionUsecase>(),
    ),
    tag: 'checkout',
  );

  final screenSize = MediaQuery.of(context).size;
  final isWide = screenSize.width >= 700;

  // Fires exactly once, the moment payment succeeds. Closes every open
  // sheet/dialog stacked on this route (checkout flow, plus the cart
  // bottom sheet beneath it on mobile) back to the billing page in one
  // shot, then opens the receipt.
  once<bool>(checkoutController.paymentSuccessful, (success) async {
    if (!success) return;

    final bill = checkoutController.completedBill.value;

    Navigator.of(
      context,
      rootNavigator: true,
    ).popUntil((route) => route.isFirst);

    Get.delete<CheckoutController>(tag: 'checkout');

    if (bill != null) {
      await showReceiptDialog(context, bill: bill);
    }
  });

  if (isWide) {
    final dialogWidth = screenSize.width < 480 ? screenSize.width : 460.0;
    final dialogHeight = screenSize.height < 700
        ? screenSize.height * .9
        : 680.0;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 24),
          backgroundColor: Colors.transparent,
          child: Center(
            child: SizedBox(
              width: dialogWidth,
              height: dialogHeight,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: CheckoutFlow(
                  checkoutController: checkoutController,
                  cartController: cartController,
                  onEditCart: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ),
        );
      },
    );
  } else {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(top: screenSize.height * .06),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              color: Colors.white,
              child: CheckoutFlow(
                checkoutController: checkoutController,
                cartController: cartController,
                onEditCart: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        );
      },
    );
  }
}
