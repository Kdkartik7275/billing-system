import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingCartSummaryPanel extends StatelessWidget {
  final CartController cartController;
  final VoidCallback onCheckout;

  const BillingCartSummaryPanel({
    super.key,
    required this.cartController,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // ---------------- HEADER ----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  "Cart",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${cartController.totalItems} items",
                      style: theme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ---------------- CART ITEMS ----------------
          Expanded(
            child: Obx(() {
              final items = cartController.cartItems.values.toList();

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 46,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Cart is empty",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (_, index) {
                  final item = items[index];
                  final tax = item.product.tax;
                  final basePrice = item.product.price.sellingPrice;
                  final unitFinalPrice = item.product.finalSellingPrice;
                  final lineTotal = unitFinalPrice * item.quantity;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- TOP ROW: THUMBNAIL / NAME / DELETE ----------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: item.product.images.first.url,
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "₹${basePrice.toStringAsFixed(2)}",
                                      ),
                                      if (!tax.isExempt && tax.gstPercent > 0)
                                        TextSpan(
                                          text:
                                              " + GST ${tax.gstPercent.toStringAsFixed(0)}%",
                                        ),
                                      TextSpan(
                                        text:
                                            " = ₹${unitFinalPrice.toStringAsFixed(2)} each",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.bodySmall?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () =>
                                cartController.removeFromCart(item.product.id),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ---------- BOTTOM ROW: STEPPER / LINE TOTAL ----------
                      Row(
                        children: [
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xff2962FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => cartController.decrementQuantity(
                                    item.product.id,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  child: const SizedBox(
                                    width: 30,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  child: Text(
                                    "${item.quantity}",
                                    textAlign: TextAlign.center,
                                    style: theme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cartController.incrementQuantity(
                                    item.product.id,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  child: const SizedBox(
                                    width: 30,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "₹${lineTotal.toStringAsFixed(2)}",
                            style: theme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          const Divider(height: 1),

          // ---------------- TOTAL / CHECKOUT ----------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Subtotal",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₹${cartController.subtotal.toStringAsFixed(2)}",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "GST",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₹${cartController.totalTax.toStringAsFixed(2)}",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                        "₹${cartController.totalAmount.toStringAsFixed(2)}",
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2962FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
