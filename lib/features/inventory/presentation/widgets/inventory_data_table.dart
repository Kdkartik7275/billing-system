import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'stock_status_badge.dart';

class InventoryDataTable extends StatelessWidget {
  const InventoryDataTable({super.key});

  static final BoxDecoration _containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final Divider _thinDivider = Divider(
    height: 1,
    color: Colors.grey.withValues(alpha: 0.12),
  );

  static final Divider _headerDivider = Divider(
    height: 1,
    color: Colors.grey.withValues(alpha: 0.1),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth < 1200
            ? 1200.0
            : constraints.maxWidth;

        // Bound the vertical extent of the row list so it can use a real
        // (non-shrinkWrap) ListView.builder, which lazily builds only the
        // rows that are actually visible instead of laying out every row
        // up-front (as ListView.separated(shrinkWrap: true) does).
        final maxTableHeight = MediaQuery.sizeOf(context).height * 0.62;

        return Container(
          decoration: _containerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ───────────────────────────────────────
              const RepaintBoundary(child: _TableTitleRow()),

              _thinDivider,

              // ── Table Area ──────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RepaintBoundary(child: _TableHeader()),
                      _headerDivider,
                      _TableBody(maxHeight: maxTableHeight),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TITLE ROW ("Products (n)" + refresh) — scoped Obx, isolated
// from header/body so sort/filter changes never rebuild this.
// ─────────────────────────────────────────────────────────────

class _TableTitleRow extends StatelessWidget {
  const _TableTitleRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              'Products (${controller.filteredProducts.length})',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
          InkWell(
            onTap: () => controller.refreshProducts(),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TABLE BODY — the only part that rebuilds when sort/filter/data
// changes. Header, title row and outer container are untouched.
// ─────────────────────────────────────────────────────────────

class _TableBody extends StatelessWidget {
  final double maxHeight;

  const _TableBody({required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return const SizedBox(
          height: 220,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
                SizedBox(height: 10),
                Text('No products found', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.builder(
          shrinkWrap: true,
          // Real (non-Never) physics: this list virtualizes and scrolls
          // on its own once content exceeds maxHeight, instead of forcing
          // every row to be laid out up-front.
          physics: const ClampingScrollPhysics(),
          cacheExtent: 600,
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return RepaintBoundary(
              key: ValueKey(product.sku),
              child: _ProductRow(
                product: product,
                showDivider: i != products.length - 1,
              ),
            );
          },
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// TABLE HEADER
// ─────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      child: Row(
        children: [
          _HeaderCell(
            'Product',
            flex: 3,
            column: 'name',
            controller: controller,
          ),
          _HeaderCell('SKU', flex: 2, column: 'sku', controller: controller),
          _HeaderCell(
            'Category',
            flex: 2,
            column: 'category',
            controller: controller,
          ),
          _HeaderCell(
            'Price',
            flex: 1,
            column: 'price',
            controller: controller,
          ),
          _HeaderCell(
            'Stock',
            flex: 2,
            column: 'stock',
            controller: controller,
          ),
          _HeaderCell(
            'Supplier',
            flex: 2,
            column: 'supplier',
            controller: controller,
          ),

          // Non-sortable
          _HeaderCell(
            'Status',
            flex: 2,
            column: '',
            controller: controller,
            sortable: false,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HEADER CELL
// ─────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final String column;
  final InventoryController controller;
  final bool sortable;

  const _HeaderCell(
    this.label, {
    required this.flex,
    required this.column,
    required this.controller,
    this.sortable = true,
  });

  static final TextStyle _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.grey.shade500,
    letterSpacing: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    // NON SORTABLE
    if (!sortable) {
      return Expanded(
        flex: flex,
        child: Text(label, style: _labelStyle),
      );
    }

    // SORTABLE — only this cell's Obx rebuilds when sort state changes,
    // never the whole header row.
    return Expanded(
      flex: flex,
      child: Obx(() {
        final isActive = controller.sortColumn.value == column;

        return GestureDetector(
          onTap: () => controller.setSort(column),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.primary : Colors.grey.shade500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                isActive
                    ? (controller.sortAscending.value
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded)
                    : Icons.unfold_more_rounded,
                size: 13,
                color: isActive ? AppColors.primary : Colors.grey.shade400,
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PRODUCT ROW
// ─────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final InventoryProduct product;
  final bool showDivider;

  const _ProductRow({required this.product, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              // PRODUCT
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 42,
                          height: 42,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            filterQuality: FilterQuality.low,
                            // Decode at display resolution (x2 for
                            // high-DPI screens) instead of full source
                            // size, cutting decode cost and memory.
                            cacheWidth: 84,
                            cacheHeight: 84,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade100,
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.barcode,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // SKU
              Expanded(
                flex: 2,
                child: Text(
                  product.sku,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // CATEGORY
              Expanded(
                flex: 2,
                child: Text(
                  product.category,
                  style: const TextStyle(fontSize: 13),
                ),
              ),

              // PRICE
              Expanded(
                flex: 1,
                child: Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // STOCK
              Expanded(
                flex: 2,
                child: Text(
                  '${product.stock} ${product.stockUnit}',
                  style: TextStyle(
                    fontSize: 13,
                    color: product.stock < 20
                        ? Colors.orange.shade700
                        : Colors.grey.shade800,
                    fontWeight: product.stock < 20
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),

              // SUPPLIER
              Expanded(
                flex: 2,
                child: Text(
                  product.supplier,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),

              // STATUS
              Expanded(
                flex: 2,
                child: StockStatusBadge(status: product.status),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.08),
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}