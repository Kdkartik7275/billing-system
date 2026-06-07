import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/indicators/progress_indicator.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/cart/cart_panel.dart';
import '../widgets/product/product_grid.dart';
import '../widgets/shared/category_tabs.dart';
import '../widgets/shared/search_field_and_scanner.dart';

class PosMobileLayout extends StatelessWidget {
  const PosMobileLayout({super.key});

  void _openCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Expanded(child: CartPanel()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final inventoryController = Get.find<InventoryController>();

    return Scaffold(
      body: Obx(
        () =>inventoryController.loading.value
                ? circularProgress(context)
                :  inventoryController.products.isEmpty
            ? const Center(child: Text('No products available'))
            :  Column(
          children: [
            // ── Search + tabs ──────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchFieldAndScanner(),
                  SizedBox(height: 10),
                  CategoryTabs(),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
        
            // ── Product grid ────────────────────────────────────
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: ProductGrid(maxCardExtent: 180, cardHeight: 250),
              ),
            ),
          ],
        ),
      ),

      // ── Sticky cart bottom bar ──────────────────────────────
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Obx(
          () => controller.cartItems.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () => _openCartSheet(context),
                  child: Container(
                    height: 64,
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                     
                    ),
                    child: Row(
                      children: [
                        // Cart badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${controller.totalItemCount} items',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'View Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        const Spacer(),
                        // Grand total
                        Text(
                          '₹${controller.grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}