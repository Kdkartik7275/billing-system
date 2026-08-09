import 'package:billing_system/features/inventory/presentation/views/add_product/edit_product_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/theme/app_radius.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/stock_entity.dart';
import '../controller/inventory_controller.dart';
import 'status_chip.dart';

const double _cardBreakpoint = 640.0;

class _ColW {
  static const double thumb = 42;
  static const double product = 220;
  static const double barcode = 130;
  static const double sku = 120;
  static const double category = 130;
  static const double brand = 120;
  static const double supplier = 150;
  static const double purchase = 100;
  static const double selling = 100;
  static const double stock = 100;
  static const double gst = 70;
  static const double status = 140;
  static const double menu = 40;

  static double get total =>
      thumb +
      AppSpacing.md +
      product +
      barcode +
      sku +
      category +
      brand +
      supplier +
      purchase +
      selling +
      stock +
      gst +
      status +
      menu +
      (AppSpacing.xl * 2);
}

class InventoryDataTable extends StatefulWidget {
  final ValueChanged<ProductEntity> onDelete;

  const InventoryDataTable({super.key, required this.onDelete});

  static const double _headerHeight = 44.0;
  static const double _minBodyHeight = 140.0;

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
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        if (availableWidth < _cardBreakpoint) {
          return _CardListFallback(onDelete: widget.onDelete);
        }

        final minTableWidth = _ColW.total;

        final tableWidth = availableWidth < minTableWidth
            ? minTableWidth
            : availableWidth;

        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.6;

        final maxBodyHeight =
            (availableHeight - InventoryDataTable._headerHeight - 3).clamp(
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

class _CardListFallback extends StatelessWidget {
  final ValueChanged<ProductEntity> onDelete;

  const _CardListFallback({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No products found',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) =>
            _ProductListCard(product: products[i], onDelete: onDelete),
      );
    });
  }
}

class _ProductListCard extends StatelessWidget {
  final ProductEntity product;
  final ValueChanged<ProductEntity> onDelete;

  const _ProductListCard({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final status = controller.stockStatusFor(product);
    final stockQty = controller.stockQuantityFor(product.id);
    final unit = controller.unitShortCode(product.unitId);

    return InkWell(
      onTap: () => controller.selectProduct(product),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                width: 48,
                height: 48,
                child: product.primaryImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: product.primaryImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _thumbPlaceholder(),
                        errorWidget: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          splashRadius: 15,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          onSelected: (action) async {
                            switch (action) {
                              case 'view':
                                controller.selectProduct(product);
                                break;
                              case 'edit':
                                final result = await Get.to<ProductEntity>(
                                  () => EditProductPage(product: product),
                                );

                                if (result != null) {
                                  controller.updateProduct(result);
                                }
                                break;
                              case 'delete':
                                onDelete(product);
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'view', child: Text('View')),
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${controller.categoryName(product.categoryId)} · SKU ${product.sku}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.sellingPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${stockQty.toStringAsFixed(0)} $unit',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Spacer(),
                      StatusChip(status: status),
                    ],
                  ),
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
            return RepaintBoundary(
              key: ValueKey(product.id),
              child: _ProductRow(
                product: product,

                isLast: i == products.length - 1,
                onDelete: onDelete,
              ),
            );
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
          SizedBox(width: _ColW.thumb),
          SizedBox(width: AppSpacing.md),
          _HeaderCell('Product', width: _ColW.product, column: 'name'),
          _HeaderCell('Barcode', width: _ColW.barcode, column: ''),
          _HeaderCell('SKU', width: _ColW.sku, column: 'sku'),
          _HeaderCell('Category', width: _ColW.category, column: 'category'),
          _HeaderCell('Brand', width: _ColW.brand, column: ''),
          _HeaderCell('Supplier', width: _ColW.supplier, column: 'supplier'),
          _HeaderCell('Purchase', width: _ColW.purchase, column: ''),
          _HeaderCell('Selling', width: _ColW.selling, column: 'price'),
          _HeaderCell('Stock', width: _ColW.stock, column: 'stock'),
          _HeaderCell('GST', width: _ColW.gst, column: ''),
          _HeaderCell(
            'Status',
            width: _ColW.status,
            column: '',
            sortable: false,
          ),
          SizedBox(width: _ColW.menu),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final String column;
  final bool sortable;

  const _HeaderCell(
    this.label, {
    required this.width,
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
      return SizedBox(
        width: width,
        child: Text(label, style: labelStyle, overflow: TextOverflow.ellipsis),
      );
    }

    final controller = Get.find<InventoryController>();

    return SizedBox(
      width: width,
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
  final bool isLast;
  final ValueChanged<ProductEntity> onDelete;

  const _ProductRow({
    required this.product,
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
          color: Colors.white,
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
                width: _ColW.thumb,
                height: _ColW.thumb,
                child: product.primaryImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: product.primaryImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _thumbPlaceholder(),
                        errorWidget: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: _ColW.product,
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
            SizedBox(
              width: _ColW.barcode,
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
            SizedBox(
              width: _ColW.sku,
              child: Text(
                product.sku,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(
              width: _ColW.category,
              child: Text(
                controller.categoryName(product.categoryId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            SizedBox(
              width: _ColW.brand,
              child: Text(
                controller.brandName(product.brandId) ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            SizedBox(
              width: _ColW.supplier,
              child: Text(
                controller.supplierName(product.primarySupplierId) ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            SizedBox(
              width: _ColW.purchase,
              child: Text(
                '₹${product.price.purchasePrice.toStringAsFixed(0)}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(
              width: _ColW.selling,
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
            SizedBox(
              width: _ColW.stock,
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
            SizedBox(
              width: _ColW.gst,
              child: Text(
                '${product.tax.gstPercent.toStringAsFixed(0)}%',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(
              width: _ColW.status,
              child: StatusChip(status: status),
            ),
            SizedBox(
              width: _ColW.menu,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                onSelected: (action) async {
                  switch (action) {
                    case 'view':
                      controller.selectProduct(product);
                      break;
                    case 'edit':
                      final result = await Get.to<ProductEntity>(
                        () => EditProductPage(product: product),
                      );

                      if (result != null) {
                        controller.updateProduct(result);
                      }
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
