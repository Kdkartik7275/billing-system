import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final double maxCardExtent;
  final double cardHeight;

  const ProductGrid({
    super.key,
    this.maxCardExtent = 220,
    this.cardHeight = 240,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final inventoryController = Get.find<InventoryController>();

    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('No products found', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCardExtent,
          mainAxisExtent: cardHeight,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,

        itemBuilder: (_, i) {
          final product = products[i];
          return Obx(
            () => ProductCard(
              product: product,
              batches: inventoryController.productBatches[product.id] ?? [],
              qty: controller.cartQty(product.id),
              onAddBatch: (batch, qty) => controller.addToCart(product, batch),
              onIncrement: () => controller.incrementCartItem(product.id),
              onRemove: () => controller.removeFromCart(product.id),
            ),
          );
        },
      );
    });
  }
}
