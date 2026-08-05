import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/shared/product_detail_shared.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/views/add_product/edit_product_page.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/dummy_stock_data.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/product_stats_row.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/quick_action_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/segmented_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailWebLayout extends StatefulWidget {
  final ProductEntity product;
  final StockEntity? stock;

  const ProductDetailWebLayout({super.key, required this.product, this.stock});

  @override
  State<ProductDetailWebLayout> createState() => _ProductDetailWebLayoutState();
}

class _ProductDetailWebLayoutState extends State<ProductDetailWebLayout> {
  int _tabIndex = 0;

  static const double _leftPaneWidth = 400;
  static const double _maxContentWidth = 1200;

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
      final batches = DummyStockData.batches(current.id);
      final movements = DummyStockData.movements(current.id);

      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(context, controller, current),
            // Wrapping the whole content area in a scroll view is the fix
            // for the overflow: the left/right panes size to their content
            // (no internal Expanded/scroll), so when that content is taller
            // than the viewport, the page itself needs to scroll rather than
            // trying to force everything into a fixed-height Center/Row.
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- LEFT PANE ----------------
                          SizedBox(
                            width: _leftPaneWidth,
                            child: Column(
                              children: [
                                ProductInfoCard(
                                  product: current,
                                  controller: controller,
                                ),
                                const SizedBox(height: 14),
                                StockStatsRow(
                                  totalStock: summary.totalQty,
                                  reservedStock: summary.reservedQty,
                                  unit: summary.unit,
                                  warehouseName: summary.warehouseName,
                                ),
                                const SizedBox(height: 14),
                                QuickActionGrid(
                                  actions: buildProductQuickActions(current),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // ---------------- RIGHT PANE ----------------
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.lg,
                                ),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: SegmentedTabBar(
                                      tabs: kProductDetailTabs,
                                      icons: kProductDetailTabIcons,
                                      selectedIndex: _tabIndex,
                                      onChanged: (index) =>
                                          setState(() => _tabIndex = index),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: buildProductDetailTabContent(
                                        tabIndex: _tabIndex,
                                        batches: batches,
                                        movements: movements,
                                        current: current,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTopBar(
    BuildContext context,
    InventoryController controller,
    ProductEntity current,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to Inventory',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '·',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.textPlaceholder),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              current.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => Get.to(() => EditProductPage(product: current)),
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            label: const Text(
              'Edit',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') {
                controller.deleteProduct(current.id);
                Get.back();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
