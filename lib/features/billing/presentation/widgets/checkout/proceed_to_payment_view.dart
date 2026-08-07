import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/checkout_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/order_summary_tile.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProceedToPaymentView extends StatelessWidget {
  final CheckoutController checkoutController;
  final CartController cartController;
  final VoidCallback onEditCart;

  const ProceedToPaymentView({
    super.key,
    required this.checkoutController,
    required this.cartController,
    required this.onEditCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        // ---------------- HEADER ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                "Proceed to Payment",
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onEditCart,
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: const Text("Edit Cart"),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff2962FF),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            cacheExtent: 400,
            slivers: [
              // ---------------- CUSTOMER ----------------
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer",
                        style: theme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Obx(
                              () => Expanded(
                                child: Text(
                                  checkoutController.customerName.value,
                                  style: theme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Order Summary",
                        style: theme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- ORDER SUMMARY (LAZY LIST) ----------------
              // This Obx works because its builder eagerly reads
              // cartController.cartItems.values right here — not deferred
              // into itemBuilder — so GetX registers the listener correctly.
              Obx(() {
                final items = cartController.cartItems.values.toList();

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) =>
                        OrderSummaryTile(item: items[index]),
                  ),
                );
              }),

              // ---------------- BILL BREAKDOWN + PAYMENT METHOD HEADER ----------------
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(
                          () => Column(
                            children: [
                              _BillRow(
                                label: "Subtotal",
                                value: checkoutController.subtotal,
                              ),
                              const SizedBox(height: 8),
                              _BillRow(
                                label: "Discount",
                                value: -checkoutController.discount.value,
                                valueColor: const Color(0xff2E7D32),
                              ),
                              const SizedBox(height: 8),
                              _BillRow(
                                label: "Tax (GST)",
                                value: checkoutController.tax,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(height: 1),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Grand Total",
                                    style: theme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                                    style: theme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff2962FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Select Payment Method",
                        style: theme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ---------------- PAYMENT METHODS (LAZY LIST) ----------------
              // No Obx wrapping the sliver itself — SliverList's itemBuilder
              // is lazy, so an Obx placed here never reads an observable
              // during its own build and GetX can't register it. Instead,
              // each tile wraps itself in its own Obx inside itemBuilder.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverList.separated(
                  itemCount: PaymentMethodType.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final type = PaymentMethodType.values[index];

                    return Obx(
                      () => PaymentMethodTile(
                        type: type,
                        isSelected:
                            checkoutController.selectedMethod.value == type,
                        onTap: () =>
                            checkoutController.selectPaymentMethod(type),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // ---------------- FOOTER ----------------
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payable Amount",
                      style: theme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Obx(
                      () => Text(
                        "₹${checkoutController.grandTotal.toStringAsFixed(2)}",
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: checkoutController.goToReceivePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2962FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Collect Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;

  const _BillRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          label,
          style: theme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          "${value < 0 ? '- ' : ''}₹${value.abs().toStringAsFixed(2)}",
          style: theme.bodyMedium?.copyWith(
            color: valueColor ?? Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}