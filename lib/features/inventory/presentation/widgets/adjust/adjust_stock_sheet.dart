import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/adjust_stock_usecase.dart';
import 'package:billing_system/features/inventory/presentation/controller/adjust_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/dialog_header_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/entity_summar_card.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/labeled_dropdown.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/labeled_textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showAdjustStockSheet(
  BuildContext context, {
  required ProductEntity product,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.72,
      child: _AdjustStockSheet(product: product),
    ),
  );
}

class _AdjustStockSheet extends StatefulWidget {
  final ProductEntity product;

  const _AdjustStockSheet({required this.product});

  @override
  State<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<_AdjustStockSheet> {
  late final AdjustStockController controller;
  late final String tag;

  @override
  void initState() {
    super.initState();
    tag =
        'adjust_${widget.product.id}_${DateTime.now().microsecondsSinceEpoch}';
    controller = Get.put(
      AdjustStockController(product: widget.product, adjustStockUsecase: sl()),
      tag: tag,
    );
  }

  @override
  void dispose() {
    Get.delete<AdjustStockController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: DialogHeaderBar(
              icon: Icons.tune_rounded,
              iconColor: Colors.orange.shade700,
              title: 'Adjust Stock',
              subtitle: 'Correct the stock quantity for this product',
              onClose: () => Get.back(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Product'),
                  const SizedBox(height: 8),
                  EntitySummaryHeader(
                    title: product.name,
                    subtitle:
                        'SKU: ${product.sku} • Barcode: ${product.barcode.isEmpty ? '—' : product.barcode}',
                    imageUrl: product.images.isNotEmpty
                        ? product.images.first.url
                        : null,
                    isActive: product.settings.isActive,
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => LabeledDropdownField(
                      label: 'Warehouse',
                      required: true,
                      value: controller.warehouseId.value,
                      options: warehouses,
                      onChanged: (v) => controller.warehouseId.value = v,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Adjustment Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ---------------- DIRECTION TOGGLE ----------------
                  const FieldLabel('Direction'),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _DirectionChip(
                            label: 'Increase',
                            icon: Icons.add_rounded,
                            color: const Color(0xFF12B76A),
                            selected:
                                controller.direction.value ==
                                AdjustmentDirection.increase,
                            onTap: () => controller.direction.value =
                                AdjustmentDirection.increase,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DirectionChip(
                            label: 'Decrease',
                            icon: Icons.remove_rounded,
                            color: Colors.red.shade600,
                            selected:
                                controller.direction.value ==
                                AdjustmentDirection.decrease,
                            onTap: () => controller.direction.value =
                                AdjustmentDirection.decrease,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Quantity',
                          required: true,
                          controller: controller.quantityController,
                          keyboardType: TextInputType.number,
                          suffixText: 'pcs',
                          onChanged: controller.onQuantityChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => LabeledDropdownField(
                            label: 'Reason',
                            required: true,
                            value: AdjustStockController
                                .reasonOptions[controller.reasonType.value],
                            options: AdjustStockController.reasonOptions.values
                                .toList(),
                            onChanged: (v) {
                              final entry = AdjustStockController
                                  .reasonOptions
                                  .entries
                                  .firstWhere((e) => e.value == v);
                              controller.reasonType.value = entry.key;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Notes',
                    hintText: 'Add any additional details...',
                    controller: controller.notesController,
                    maxLength: 200,
                    showCounter: true,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveAdjustment,
                        icon: controller.isSaving.value
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 18),
                        label: Text(
                          controller.isSaving.value
                              ? 'Saving...'
                              : 'Save Adjustment',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          disabledBackgroundColor: Colors.orange.shade300,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- DIRECTION CHIP ----------------

class _DirectionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _DirectionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? color : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
