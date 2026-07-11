import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../shared/qty_control.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductCard({
    super.key,
    required this.product,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isInCart = qty > 0;
    final inStock = product.stock > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isInCart
              ? AppColors.primary.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.12),
          width: isInCart ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isInCart
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isInCart ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: inStock ? onAdd : null,
            splashColor: AppColors.primary.withValues(alpha: 0.06),
            highlightColor: AppColors.primary.withValues(alpha: 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ────────────────────────────────────────
                _ProductImage(
                  imageUrl: product.imageUrl,
                  isInCart: isInCart,
                  qty: qty,
                ),

                // ── Info ─────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600 
                          ),
                        ),
                        const Spacer(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: _StockBadge(stock: product.stock)),
                        const SizedBox(height: 8),

                        // ── Add / Qty ───────────────────────────
                        inStock
                            ? (qty == 0
                                  ? _AddButton(onAdd: onAdd)
                                  : QtyControl(
                                      qty: qty,
                                      onAdd: onAdd,
                                      onRemove: onRemove,
                                    ))
                            : Center(
                                child: Text(
                                  'Out of Stock',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(color: Colors.red),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Product Image with cart indicator overlay ─────────────────────────────

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final bool isInCart;
  final int qty;

  const _ProductImage({
    required this.imageUrl,
    required this.isInCart,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade100,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Add Button ────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final VoidCallback onAdd;
  const _AddButton({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 15, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stock Badge ───────────────────────────────────────────────────────────

class _StockBadge extends StatelessWidget {
  final int stock;
  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final isLow = stock < 50;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isLow
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow
              ? Colors.orange.withValues(alpha: 0.25)
              : Colors.green.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Text(
        '$stock left',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isLow ? Colors.orange.shade700 : Colors.green.shade700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
