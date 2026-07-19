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

    return RepaintBoundary(
      child: Column(
        children: [
          Obx(() {
            final itemCount = controller.cartItems.length;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Text(
                    'Cart ($itemCount ${itemCount == 1 ? 'item' : 'items'})',
                    style: tt.titleSmall,
                  ),
                  const Spacer(),
                  if (itemCount > 0)
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
                        style: tt.titleMedium?.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),

          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),

          /// Cart Items
          Expanded(
            child: Obx(() {
              final items = controller.cartItems;

              if (items.isEmpty) {
                return const _CartEmptyState();
              }

              return ListView.separated(
                cacheExtent: 800,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: Colors.grey.withValues(alpha: 0.15),
                ),
                itemBuilder: (_, index) {
                  return CartItemTile(item: items[index]);
                },
              );
            }),
          ),

          /// Footer
          Obx(() {
            if (controller.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),

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
            );
          }),
        ],
      ),
    );
  }
}

class _CartEmptyState extends StatelessWidget {
  const _CartEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add products to start billing',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
