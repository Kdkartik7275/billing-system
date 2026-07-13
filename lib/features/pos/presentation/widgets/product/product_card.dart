import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/pos/presentation/widgets/product/batch_pick.dart';
import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../shared/qty_control.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final List<StockBatch> batches;
  final int qty;
  final void Function(StockBatch batch, int quantity) onAddBatch;
  final VoidCallback onIncrement; // NEW — bumps qty on the batch already in the cart
  final VoidCallback onRemove;

  const ProductCard({
    super.key,
    required this.product,
    required this.batches,
    required this.qty,
    required this.onAddBatch,
    required this.onIncrement,
    required this.onRemove,
  });

  Future<void> _openBatchPicker(BuildContext context) async {
    if (batches.isEmpty) return;
    if (batches.length == 1) {
      onAddBatch(batches.first, 1);
      return;
    }
    final result = await showModalBottomSheet<BatchPick>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BatchPickerSheet(product: product, batches: batches),
    );
    if (result != null) {
      onAddBatch(result.batch, result.quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInCart = qty > 0;
    final inStock = product.stock > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(/* unchanged */),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // Tapping the card body: open picker only if not yet in cart.
            // Once in cart, tapping the card shouldn't silently add a unit
            // from a different batch — use the qty stepper for that.
            onTap: inStock && !isInCart ? () => _openBatchPicker(context) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImage(imageUrl: product.imageUrl, isInCart: isInCart, qty: qty),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, /* unchanged */ maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(product.category /* unchanged */),
                        const Spacer(),
                        Align(alignment: Alignment.centerRight, child: _StockBadge(stock: product.stock)),
                        const SizedBox(height: 8),
                        inStock
                            ? (qty == 0
                                ? _AddButton(onAdd: () => _openBatchPicker(context))
                                : QtyControl(
                                    qty: qty,
                                    onAdd: onIncrement, // reuses existing batch, no picker
                                    onRemove: onRemove,
                                  ))
                            : Center(
                                child: Text(
                                  'Out of Stock',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
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
