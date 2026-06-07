import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';
import '../widgets/cart/cart_panel.dart';
import '../widgets/product/product_grid.dart';
import '../widgets/shared/category_tabs.dart';
import '../widgets/shared/search_field_and_scanner.dart';

class PosWebLayout extends StatelessWidget {
  const PosWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: products ────────────────────────────────────
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchFieldAndScanner(),
                SizedBox(height: 16),
                CategoryTabs(),
                SizedBox(height: 16),
                Expanded(child: ProductGrid()),
              ],
            ),
          ),

          // ── Right: cart ───────────────────────────────────────
          Container(
            width: 400,
            height: double.infinity,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: const CartPanel(),
          ),
        ],
      ),
    );
  }
}