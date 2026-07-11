import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/chip_label.dart';
import 'package:billing_system/features/inventory/presentation/widgets/stock_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailAppBar extends StatelessWidget {
  final InventoryProduct product;

  const ProductDetailAppBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black87,
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (v) {
            if (v == 'delete') {
              Get.find<InventoryController>().deleteProduct(p.id);
              Get.back();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Edit Product'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  p.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChipLabel(label: p.category, color: AppColors.primary),
                  const SizedBox(width: 6),
                  StockStatusBadge(status: p.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
