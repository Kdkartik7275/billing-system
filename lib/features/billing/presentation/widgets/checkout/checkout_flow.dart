import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/proceed_to_payment_view.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/receive_payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutFlow extends StatelessWidget {
  final CheckoutController checkoutController;
  final CartController cartController;
  final VoidCallback onEditCart;
  final VoidCallback onClose;

  const CheckoutFlow({
    super.key,
    required this.checkoutController,
    required this.cartController,
    required this.onEditCart,
    required this.onClose,
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

      return ReceivePaymentView(
        checkoutController: checkoutController,
        onClose: onClose,
      );
    });
  }
}

// ---------------- DIALOG LAUNCHER ----------------

Future<void> showCheckoutFlow(
  BuildContext context, {
  required CartController cartController,
}) async {
  final checkoutController = Get.put(
    CheckoutController(cartController: cartController),
    tag: 'checkout',
  );

  final isWide = MediaQuery.of(context).size.width >= 700;

  void closeAndReset() {
    Navigator.of(context).maybePop();
    cartController.clearCart();
    Get.delete<CheckoutController>(tag: 'checkout');
  }

  if (isWide) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 24),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: 460,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: CheckoutFlow(
                checkoutController: checkoutController,
                cartController: cartController,
                onEditCart: () => Navigator.of(context).maybePop(),
                onClose: closeAndReset,
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .06,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              color: Colors.white,
              child: CheckoutFlow(
                checkoutController: checkoutController,
                cartController: cartController,
                onEditCart: () => Navigator.of(context).maybePop(),
                onClose: closeAndReset,
              ),
            ),
          ),
        );
      },
    );
  }
}
