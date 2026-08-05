import 'package:billing_system/core/shared/product_detail_shared.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/controller/product_detail_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/edit_product_page.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_stats_row.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/quick_action_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/segmented_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailTabletLayout extends StatefulWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailTabletLayout({
    super.key,
    required this.product,
    this.stock,
  });

  @override
  State<ProductDetailTabletLayout> createState() =>
      _ProductDetailTabletLayoutState();
}

class _ProductDetailTabletLayoutState extends State<ProductDetailTabletLayout> {
  int _tabIndex = 0;

  static const double _leftPaneWidth = 380;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final productController = Get.find<ProductDetailController>();

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
            TextButton.icon(
              onPressed: () => Get.to(() => EditProductPage(product: current)),
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.black87,
              ),
              label: const Text(
                'Edit',
                style: TextStyle(color: Colors.black87),
              ),
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
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- LEFT PANE ----------------
            SizedBox(
              width: _leftPaneWidth,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 24),
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
                ],
              ),
            ),
            VerticalDivider(width: 1, color: Colors.grey.shade200),
            // ---------------- RIGHT PANE ----------------
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SegmentedTabBar(
                      tabs: kProductDetailTabs,
                      icons: kProductDetailTabIcons,
                      selectedIndex: _tabIndex,
                      onChanged: (index) => setState(() => _tabIndex = index),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      children: buildProductDetailTabContent(
                        tabIndex: _tabIndex,
                        batches: productController.stockBatches,
                        movements: productController.stockMovements,
                        current: current,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
