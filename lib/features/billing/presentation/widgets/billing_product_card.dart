import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BillingProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String sku;
  final int stock;
  final double price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const BillingProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.sku,
    required this.stock,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE ----------------
            Expanded(
              flex: 3,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 130),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    memCacheWidth: 300,
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },

                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade500,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---------------- NAME / SKU ----------------
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              "SKU: $sku",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),

            const SizedBox(height: 6),

            // ---------------- STOCK CHIP ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xffEAF8ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "In Stock: $stock",
                style: theme.bodySmall?.copyWith(
                  color: const Color(0xff2E7D32),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---------------- PRICE / CART ACTION ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    "₹${price.toStringAsFixed(2)}",
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                quantity == 0
                    ? InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xff2962FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    : Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xff2962FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: onDecrement,
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 28,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 18,
                              child: Text(
                                "$quantity",
                                textAlign: TextAlign.center,
                                style: theme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onIncrement,
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 28,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
