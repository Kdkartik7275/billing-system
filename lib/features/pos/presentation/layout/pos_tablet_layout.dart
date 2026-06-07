import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';

import '../widgets/cart/cart_panel.dart';
import '../widgets/product/product_grid.dart';
import '../widgets/shared/category_tabs.dart';
import '../widgets/shared/search_field_and_scanner.dart';

class PosTabletLayout extends StatelessWidget {
  const PosTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: products ────────────────────────────────
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchFieldAndScanner(),
                  SizedBox(height: 14),
                  CategoryTabs(),
                  SizedBox(height: 14),
                  Expanded(
                    child: ProductGrid(maxCardExtent: 200, cardHeight: 240),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: const CartPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
