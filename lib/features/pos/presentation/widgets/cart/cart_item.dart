import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:billing_system/features/pos/presentation/widgets/shared/qty_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';


class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 46,
              height: 46,
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + unit price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall,
                ),
                const SizedBox(height: 3),
                Obx(
                  () => Text(
                    '₹${item.product.price.toStringAsFixed(0)} × '
                    '${controller.cartQty(item.product.id)}',
                    style: tt.bodySmall!.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Qty stepper
          Obx(
            () => QtyControl(
              qty: controller.cartQty(item.product.id),
              onAdd: () => controller.addToCart(item.product),
              onRemove: () => controller.removeFromCart(item.product.id),
            ),
          ),
          const SizedBox(width: 14),

          // Line total + delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  '₹${(item.product.price * controller.cartQty(item.product.id)).toStringAsFixed(0)}',
                  style: tt.titleSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.deleteCartItem(item.product.id),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}