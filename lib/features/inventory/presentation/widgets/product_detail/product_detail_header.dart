import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class ProductDetailHeader extends StatelessWidget {
  final ProductEntity product;
  final StockEntity? stock;
  final double imageSize;

  const ProductDetailHeader({
    super.key,
    required this.product,
    this.stock,
    this.imageSize = 72,
  });

  @override
  Widget build(BuildContext context) {
    final status = stock?.statusFor(product.settings.lowStockThreshold);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: product.primaryImageUrl != null
                ? Image.network(
                    product.primaryImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(),
                  )
                : _fallback(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SKU ${product.sku}',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              if (status != null) StatusChip(status: status),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: imageSize * 0.4,
      ),
    );
  }
}
