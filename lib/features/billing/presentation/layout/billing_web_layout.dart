import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_product_grid_tile.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/checkout_flow.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_cart_summary_panel.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_category_filter.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_empty_state.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_search_bar.dart';
import 'package:billing_system/features/billing/presentation/widgets/scan/billing_scan_handler.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingWebLayout extends StatefulWidget {
  const BillingWebLayout({super.key});

  @override
  State<BillingWebLayout> createState() => _BillingWebLayoutState();
}

class _BillingWebLayoutState extends State<BillingWebLayout> {
  final TextEditingController _textController = TextEditingController();
  late InventoryController inventoryController;
  late BillingController controller;
  late CartController cartController;

  static const double _cartPanelWidth = 380;
  static const double _maxContentWidth = 1600;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BillingController>();
    inventoryController = Get.find<InventoryController>();
    cartController = Get.put<CartController>(
      CartController(
        getAvailableStock: (productId) =>
            inventoryController.stockQuantityFor(productId).toInt(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------- PRODUCT SECTION -----------
                Expanded(
                  child: Column(
                    children: [
                      BillingSearchBar(
                        controller: _textController,
                        onChanged: controller.updateSearch,
                        onScanTap: () => BillingScanHandler.scanAndAddToCart(
                          context: context,
                          inventoryController: inventoryController,
                          cartController: cartController,
                        ),
                      ),

                      const SizedBox(height: 16),

                      BillingCategoryFilter(
                        categories: [
                          'All',
                          ...inventoryController.categories.map((c) => c.name),
                        ],
                        selectedCategory: controller.selectedCategory,
                        onSelect: controller.selectCategory,
                        height: 54,
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: Obx(() {
                          final products = controller.filteredProducts;

                          if (products.isEmpty) {
                            return const BillingEmptyProductsView();
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 210,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: .80,
                                ),
                            itemBuilder: (_, index) {
                              return BillingProductGridTile(
                                product: products[index],
                                inventoryController: inventoryController,
                                cartController: cartController,
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
                SizedBox(
                  width: _cartPanelWidth,
                  child: BillingCartSummaryPanel(
                    cartController: cartController,
                    onCheckout: () => showCheckoutFlow(
                      context,
                      cartController: cartController,
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
