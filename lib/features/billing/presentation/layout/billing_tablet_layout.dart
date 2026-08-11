import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_cart_summary_panel.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_category_filter.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_empty_state.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_product_card.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_search_bar.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/checkout_flow.dart';
import 'package:billing_system/features/billing/presentation/widgets/scan/billing_scan_handler.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingTabletLayout extends StatefulWidget {
  const BillingTabletLayout({super.key});

  @override
  State<BillingTabletLayout> createState() => _BillingTabletLayoutState();
}

class _BillingTabletLayoutState extends State<BillingTabletLayout> {
  final TextEditingController _textController = TextEditingController();
  late InventoryController inventoryController;
  late BillingController controller;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BillingController>();
    inventoryController = Get.find<InventoryController>();
    cartController = Get.put<CartController>(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------- PRODUCT SECTION -----------
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  BillingSearchBar(
                    controller: _textController,
                    onChanged: (val) {},
                    onScanTap: () => BillingScanHandler.scanAndAddToCart(
                      context: context,
                      inventoryController: inventoryController,
                      cartController: cartController,
                    ),
                  ),

                  const SizedBox(height: 14),

                  BillingCategoryFilter(
                    categories: [
                      'All',
                      ...inventoryController.categories.map((c) => c.name),
                    ],
                    selectedCategory: controller.selectedCategory,
                    onSelect: controller.selectCategory,
                    height: 54,
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: Obx(() {
                      final products = controller.filteredProducts;
                      cartController.cartItems.length;

                      if (products.isEmpty) {
                        return const BillingEmptyProductsView();
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: .68,
                            ),
                        itemBuilder: (_, index) {
                          final product = products[index];

                          return BillingProductCard(
                            imageUrl: product.images.first.url,
                            name: product.name,
                            sku: product.sku,
                            stock: inventoryController
                                .stockQuantityFor(product.id)
                                .toInt(),
                            price: product.price.sellingPrice,
                            quantity: cartController.quantityFor(product.id),
                            onAdd: () => cartController.addToCart(product),
                            onIncrement: () =>
                                cartController.incrementQuantity(product.id),
                            onDecrement: () =>
                                cartController.decrementQuantity(product.id),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // ----------- CART SECTION -----------
            Expanded(
              flex: 1,
              child: BillingCartSummaryPanel(
                cartController: cartController,
                onCheckout: () =>
                    showCheckoutFlow(context, cartController: cartController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
