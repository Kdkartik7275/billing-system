import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/add_movement_sheet.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/analytics_tab.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/bottom_action_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/overview_tab.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/product_detail_app_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/product_detail_tab_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/stock_history_tab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatefulWidget {
  final InventoryProduct product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  late InventoryController controller;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    controller = Get.find<InventoryController>();
    controller.getProductMovementLogs(widget.product.id);
    controller.getProductStockBatches(widget.product.id);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  void _showAddMovement(StockTransactionType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddMovementSheet(
        type: type,
        productId: widget.product.id,
        currentStock: widget.product.stock,
        onSave: (transaction, purchasePrice, sellingPrice)async {
          if (type == StockTransactionType.purchase) {
          await   controller.purchaseStock(
              productId: widget.product.id,
              quantity: transaction.quantityChanged,
              previousStock: widget.product.stock,
              purchasePrice: purchasePrice ?? widget.product.purchasePrice,
              sellingPrice: sellingPrice ?? widget.product.price,
            );
          }
          // setState(() => _transactions.insert(0, transaction));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, _) => [ProductDetailAppBar(product: p)],
        body: Obx(
          () => Column(
            children: [
              ProductDetailTabBar(controller: _tab),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    OverviewTab(
                      product: p,
                      fmt: _fmt,
                      batches: controller.batches,
                    ),
                    StockHistoryTab(
                      transactions: controller.transactions,
                      totalIn: controller.totalIn,
                      totalOut: controller.totalOut,
                      product: p,
                    ),
                    AnalyticsTab(
                      transactions: controller.transactions,
                      product: p,
                      fmt: _fmt,
                      totalIn: controller.totalIn,
                      totalOut: controller.totalOut,
                      totalDamaged: controller.totalDamaged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BottomActionBar(onTap: _showAddMovement),
    );
  }
}
