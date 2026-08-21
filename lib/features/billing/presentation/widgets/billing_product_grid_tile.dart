import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_product_card.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingProductGridTile extends StatelessWidget {
  final ProductEntity product;
  final InventoryController inventoryController;
  final CartController cartController;

  const BillingProductGridTile({
    super.key,
    required this.product,
    required this.inventoryController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Obx(() {
        return BillingProductCard(
          imageUrl: product.primaryImageUrl ?? '',
          name: product.name,
          sku: product.sku,
          stock: inventoryController.stockQuantityFor(product.id).toInt(),
          price: product.price.sellingPrice,
          quantity: cartController.quantityFor(product.id),
          onAdd: () => cartController.addToCart(product),
          onIncrement: () => cartController.incrementQuantity(product.id),
          onDecrement: () => cartController.decrementQuantity(product.id),
        );
      }),
    );
  }
}