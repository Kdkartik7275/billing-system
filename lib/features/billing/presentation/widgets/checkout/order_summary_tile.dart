import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderSummaryTile extends StatelessWidget {
  final CartItem item;

  const OrderSummaryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final unitPrice = item.product.finalSellingPrice;
    final lineTotal = unitPrice * item.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.product.images.first.url,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.quantity} x ₹${unitPrice.toStringAsFixed(2)}",
                style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 2),
              Text(
                "₹${lineTotal.toStringAsFixed(2)}",
                style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
