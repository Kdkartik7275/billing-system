import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:billing_system/features/pos/presentation/widgets/cart/cart_item.dart';
import 'package:billing_system/features/pos/presentation/widgets/cart/cart_summary.dart';
import 'package:billing_system/features/pos/presentation/widgets/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Text(
                  'Cart (${controller.cartItems.length} '
                  '${controller.cartItems.length == 1 ? 'item' : 'items'})',
                  style: tt.titleSmall!,
                ),
                const Spacer(),
                if (controller.cartItems.isNotEmpty)
                  TextButton(
                    onPressed: controller.clearCart,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Clear all',
                      style: tt.titleMedium!.copyWith(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),

        // ── Item list or empty state ─────────────────────────────
        Expanded(
          child: Obx(
            () => controller.cartItems.isEmpty
                ? const _CartEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.cartItems.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.15),
                    ),
                    itemBuilder: (_, i) {
                      final item = controller.cartItems[i];
                      return CartItemTile(item: item);
                    },
                  ),
          ),
        ),

        // ── Summary + checkout ───────────────────────────────────
        Obx(
          () => controller.cartItems.isNotEmpty
              ? Column(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    CartSummary(
                      subtotal: controller.subtotal,
                      tax: controller.tax,
                      grandTotal: controller.grandTotal,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            PaymentDialog.show();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _CartEmptyState extends StatelessWidget {
  const _CartEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 52,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'Cart is empty',
            style: Theme.of(  context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add products to start billing',
            style: Theme.of(  context).textTheme.titleSmall!.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
