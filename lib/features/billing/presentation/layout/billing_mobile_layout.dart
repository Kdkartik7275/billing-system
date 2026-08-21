import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/billing/presentation/controllers/cart_controller.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_cart_bar.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_cart_summary_panel.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_category_filter.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_empty_state.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_product_grid_tile.dart';
import 'package:billing_system/features/billing/presentation/widgets/billing_search_bar.dart';
import 'package:billing_system/features/billing/presentation/widgets/checkout/checkout_flow.dart';
import 'package:billing_system/features/billing/presentation/widgets/scan/billing_scan_handler.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingMobileLayout extends StatefulWidget {
  const BillingMobileLayout({super.key});

  @override
  State<BillingMobileLayout> createState() => _BillingMobileLayoutState();
}

class _BillingMobileLayoutState extends State<BillingMobileLayout> {
  final TextEditingController _textController = TextEditingController();
  late InventoryController inventoryController;
  late BillingController controller;
  late CartController cartController;

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

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .1,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BillingCartSummaryPanel(
              cartController: cartController,
              onCheckout: () =>
                  showCheckoutFlow(context, cartController: cartController),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // --------- SEARCH FIELD ------------
            BillingSearchBar(
              controller: _textController,
              onChanged: controller.updateSearch,
              onScanTap: () => BillingScanHandler.scanAndAddToCart(
                context: context,
                inventoryController: inventoryController,
                cartController: cartController,
              ),
            ),

            const SizedBox(height: 12),

            // ----------- CATEGORIES LIST -----------
            BillingCategoryFilter(
              categories: [
                'All',
                ...inventoryController.categories.map((c) => c.name),
              ],
              selectedCategory: controller.selectedCategory,
              onSelect: controller.selectCategory,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                final products = controller.filteredProducts;

                if (products.isEmpty) {
                  return const BillingEmptyProductsView();
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 210,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: .68,
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
      bottomNavigationBar: BillingCartBar(
        cartController: cartController,
        onTap: _openCartSheet,
      ),
    );
  }
}
