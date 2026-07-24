import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/inventory_controller.dart';
import 'inventory_search_bar.dart';

class InventoryFilterBar extends StatelessWidget {
  final bool isCompact;

  const InventoryFilterBar({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Obx(() {
      final filters = [
        _buildDropdown<String>(
          value: controller.selectedCategoryId.value,
          items: [
            const DropdownMenuItem(value: 'All', child: Text('Category')),
            ...controller.categories.map(
              (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
            ),
          ],
          onChanged: (v) => controller.selectCategory(v ?? 'All'),
        ),
        _buildDropdown<String>(
          value: controller.selectedBrandId.value,
          items: [
            const DropdownMenuItem(value: 'All', child: Text('Brand')),
            ...controller.brands.map(
              (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
            ),
          ],
          onChanged: (v) => controller.selectBrand(v ?? 'All'),
        ),
        _buildDropdown<String>(
          value: controller.selectedSupplierId.value,
          items: [
            const DropdownMenuItem(value: 'All', child: Text('Supplier')),
            ...controller.suppliers.map(
              (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
            ),
          ],
          onChanged: (v) => controller.selectSupplier(v ?? 'All'),
        ),
        _buildDropdown<StockFilter>(
          value: controller.selectedStockFilter.value,
          items: const [
            DropdownMenuItem(value: StockFilter.all, child: Text('All Stock')),
            DropdownMenuItem(
              value: StockFilter.inStock,
              child: Text('In Stock'),
            ),
            DropdownMenuItem(
              value: StockFilter.lowStock,
              child: Text('Low Stock'),
            ),
            DropdownMenuItem(
              value: StockFilter.outOfStock,
              child: Text('Out of Stock'),
            ),
          ],
          onChanged: (v) => controller.selectStockFilter(v ?? StockFilter.all),
        ),
      ];

      if (!isCompact) {
        return SizedBox(
          height: 44,
          child: Row(
            children: [
              const Expanded(flex: 3, child: InventorySearchBar()),
              const SizedBox(width: 14),
              ..._buildDesktopFilters(filters),
            ],
          ),
        );
      }

      return Column(
        children: [
          const InventorySearchBar(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: filters[0]),
              const SizedBox(width: 12),
              Expanded(child: filters[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: filters[2]),
              const SizedBox(width: 12),
              Expanded(child: filters[3]),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return _FilterDropdown<T>(value: value, items: items, onChanged: onChanged);
  }

  List<Widget> _buildDesktopFilters(List<Widget> filters) {
    final children = <Widget>[];

    for (int i = 0; i < filters.length; i++) {
      children.add(Expanded(child: filters[i]));

      if (i != filters.length - 1) {
        children.add(const SizedBox(width: 12));
      }
    }

    return children;
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE5E7EB)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: .03),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          elevation: 3,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Colors.black54,
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
