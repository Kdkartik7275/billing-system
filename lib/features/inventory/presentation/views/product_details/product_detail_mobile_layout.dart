import 'package:billing_system/core/card/detail_section_card.dart';
import 'package:billing_system/core/shared/product_detail_shared.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/edit_product_page.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_stats_row.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/quick_action_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/segmented_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailMobileLayout extends StatefulWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailMobileLayout({
    super.key,
    required this.product,
    this.stock,
  });

  @override
  State<ProductDetailMobileLayout> createState() =>
      _ProductDetailMobileLayoutState();
}

class _ProductDetailMobileLayoutState extends State<ProductDetailMobileLayout> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final current = controller.products.firstWhere(
        (p) => p.id == widget.product.id,
        orElse: () => widget.product,
      );
      final summary = computeProductStockSummary(
        controller: controller,
        product: current,
        fallbackStock: widget.stock,
      );

      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black87,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Product Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.black87),
              onPressed: () => Get.to(() => EditProductPage(product: current)),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (v) {
                if (v == 'delete') {
                  controller.deleteProduct(current.id);
                  Get.back();
                }
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            ProductInfoCard(product: current, controller: controller),
            const SizedBox(height: 14),
            StockStatsRow(
              totalStock: summary.totalQty,
              reservedStock: summary.reservedQty,
              unit: summary.unit,
              warehouseName: summary.warehouseName,
            ),
            const SizedBox(height: 14),
            QuickActionGrid(actions: buildProductQuickActions(current)),
            const SizedBox(height: 14),
            DetailSectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SegmentedTabBar(
                tabs: kProductDetailTabs,
                icons: kProductDetailTabIcons,
                selectedIndex: _tabIndex,
                onChanged: (index) => setState(() => _tabIndex = index),
              ),
            ),
            const SizedBox(height: 14),
            ...buildProductDetailTabContent(
              tabIndex: _tabIndex,

              current: current,
            ),
          ],
        ),
      );
    });
  }
}
