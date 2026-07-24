import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/theme/app_radius.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/stock_entity.dart';
import '../controller/inventory_controller.dart';
import 'status_chip.dart';

class InventoryDataTable extends StatefulWidget {
  final ValueChanged<ProductEntity> onDelete;

  const InventoryDataTable({super.key, required this.onDelete});

  static const double _headerHeight = 44.0;
  static const double _minBodyHeight = 140.0;

  static const double _minTableWidth = 1100.0;

  @override
  State<InventoryDataTable> createState() => _InventoryDataTableState();
}

class _InventoryDataTableState extends State<InventoryDataTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth =
            constraints.maxWidth < InventoryDataTable._minTableWidth
            ? InventoryDataTable._minTableWidth
            : constraints.maxWidth;

        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.6;

        final maxBodyHeight =
            (availableHeight - InventoryDataTable._headerHeight -3).clamp(
              InventoryDataTable._minBodyHeight,
              double.infinity,
            );

        return Container(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : double.infinity,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
           
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                 
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _TableHeader(),
                        Divider(height: 1, color: Colors.grey.shade300),
                        _TableBody(
                          maxHeight: maxBodyHeight,
                          onDelete: widget.onDelete,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableBody extends StatelessWidget {
  final double maxHeight;
  final ValueChanged<ProductEntity> onDelete;

  const _TableBody({required this.maxHeight, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final products = controller.filteredProducts;

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          cacheExtent: 600,
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return Obx(() {
              final isSelected =
                  controller.selectedProduct.value?.id == product.id;
              return RepaintBoundary(
                key: ValueKey(product.id),
                child: _ProductRow(
                  product: product,
                  isSelected: isSelected,
                  isLast: i == products.length - 1,
                  onDelete: onDelete,
                ),
              );
            });
          },
        ),
      );
    });
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InventoryDataTable._headerHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: const Row(
        children: [
          SizedBox(width: 42),
          SizedBox(width: AppSpacing.md),
          _HeaderCell('Product', flex: 3, column: 'name'),
          _HeaderCell('Barcode', flex: 2, column: ''),
          _HeaderCell('SKU', flex: 2, column: 'sku'),
          _HeaderCell('Category', flex: 2, column: 'category'),
          _HeaderCell('Brand', flex: 2, column: ''),
          _HeaderCell('Supplier', flex: 2, column: 'supplier'),
          _HeaderCell('Purchase', flex: 1, column: ''),
          _HeaderCell('Selling', flex: 1, column: 'price'),
          _HeaderCell('Stock', flex: 1, column: 'stock'),
          _HeaderCell('GST', flex: 1, column: ''),
          _HeaderCell('Status', flex: 2, column: '', sortable: false),
          SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final String column;
  final bool sortable;

  const _HeaderCell(
    this.label, {
    required this.flex,
    required this.column,
    this.sortable = true,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
      letterSpacing: 0.3,
    );

    if (!sortable || column.isEmpty) {
      return Expanded(
        flex: flex,
        child: Text(label, style: labelStyle, overflow: TextOverflow.ellipsis),
      );
    }

    final controller = Get.find<InventoryController>();

    return Expanded(
      flex: flex,
      child: Obx(() {
        final isActive = controller.sortColumn.value == column;
        return InkWell(
          onTap: () => controller.setSort(column),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle.copyWith(
                    color: isActive ? Colors.blue.shade700 : Colors.black87,
                  ),
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
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade400,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final ProductEntity product;
  final bool isSelected;
  final bool isLast;
  final ValueChanged<ProductEntity> onDelete;

  const _ProductRow({
    required this.product,
    required this.isSelected,
    required this.isLast,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final status = controller.stockStatusFor(product);
    final stockQty = controller.stockQuantityFor(product.id);
    final unit = controller.unitShortCode(product.unitId);

    return InkWell(
      onTap: () => controller.selectProduct(product),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : null,
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                width: 42,
                height: 42,
                child: product.primaryImageUrl != null
                    ? Image.network(
                        product.primaryImageUrl!,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        cacheWidth: 84,
                        cacheHeight: 84,
                        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 3,
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                product.barcode,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                product.sku,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                controller.categoryName(product.categoryId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                controller.brandName(product.brandId) ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                controller.supplierName(product.primarySupplierId) ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '₹${product.price.purchasePrice.toStringAsFixed(0)}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '₹${product.price.sellingPrice.toStringAsFixed(0)}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${stockQty.toStringAsFixed(0)} $unit',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: status == StockStatus.inStock
                      ? FontWeight.w400
                      : FontWeight.w700,
                  color: status == StockStatus.inStock
                      ? Colors.black87
                      : Colors.orange.shade700,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${product.tax.gstPercent.toStringAsFixed(0)}%',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            Expanded(flex: 2, child: StatusChip(status: status)),
            SizedBox(
              width: 40,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                onSelected: (action) {
                  switch (action) {
                    case 'view':
                      controller.selectProduct(product);
                      break;
                    case 'edit':
                      Get.snackbar(
                        'Edit Product',
                        'The edit form for "${product.name}" will be available soon.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      break;
                    case 'delete':
                      onDelete(product);
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'view', child: Text('View')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbPlaceholder() => Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: Icon(
      Icons.inventory_2_outlined,
      size: 18,
      color: Colors.grey.shade600,
    ),
  );
}
