import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'stock_status_badge.dart';

class InventoryDataTable extends StatelessWidget {
  const InventoryDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────
              Obx(
                () => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Text(
                    'Products (${controller.filteredProducts.length})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),

              // ── Table Area ──────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth < 1200
                        ? 1200
                        : constraints.maxWidth,
                    child: Column(
                      children: [
                        // Header Row
                        const _TableHeader(),

                        Divider(
                          height: 1,
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),

                        // Data Rows
                        Expanded(
                          child: Obx(() {
                            final products = controller.filteredProducts;

                            if (products.isEmpty) {
                              return const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'No products found',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                              itemCount: products.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.08),
                                indent: 20,
                                endIndent: 20,
                              ),
                              itemBuilder: (_, i) =>
                                  _ProductRow(product: products[i]),
                            );
                          }),
                        ),
                      ],
                    ),
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

          _HeaderCell(
            'Actions',
            flex: 1,
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

  @override
  Widget build(BuildContext context) {
    // NON SORTABLE
    if (!sortable) {
      return Expanded(
        flex: flex,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    // SORTABLE
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

  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Row(
        children: [
          // PRODUCT
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
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
            child: Text(product.category, style: const TextStyle(fontSize: 13)),
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
          Expanded(flex: 2, child: StockStatusBadge(status: product.status)),

          // ACTIONS
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _ActionIcon(
                  icon: Icons.edit_outlined,
                  color: Colors.blue.shade400,
                  onTap: () {},
                ),

                const SizedBox(width: 6),

                _ActionIcon(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  onTap: () => _confirmDelete(context, controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, InventoryController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Product',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text('Remove "${product.name}" from inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              controller.deleteProduct(product.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ACTION ICON
// ─────────────────────────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
