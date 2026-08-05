import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/purchase_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/dialog_header_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/entity_summar_card.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/labeled_dropdown.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/labeled_field_date.dart';
import 'package:billing_system/features/inventory/presentation/widgets/purchase/labeled_textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showAddPurchaseSheet(
  BuildContext context, {
  required ProductEntity product,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.94,
      child: _AddPurchaseSheet(product: product),
    ),
  );
}

class _AddPurchaseSheet extends StatefulWidget {
  final ProductEntity product;

  const _AddPurchaseSheet({required this.product});

  @override
  State<_AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends State<_AddPurchaseSheet> {
  late final AddPurchaseController controller;
  late final String tag;

  @override
  void initState() {
    super.initState();
    tag =
        'purchase_${widget.product.id}_${DateTime.now().microsecondsSinceEpoch}';
    controller = Get.put(
      AddPurchaseController(
        product: widget.product,
        purchaseStockUseCase: sl(),
      ),
      tag: tag,
    );
  }

  @override
  void dispose() {
    Get.delete<AddPurchaseController>(tag: tag);
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
              icon: Icons.shopping_cart_outlined,
              iconColor: const Color(0xFF12B76A),
              title: 'Add Purchase',
              subtitle: 'Add new stock to your inventory',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => LabeledDropdownField(
                            label: 'Warehouse',
                            required: true,
                            value: controller.warehouseId.value,
                            options: warehouses,

                            onChanged: (v) => controller.warehouseId.value = v,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => LabeledDateField(
                            label: 'Date',
                            required: true,
                            value: controller.date.value,
                            onChanged: (v) => controller.date.value = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Obx(
                          () => LabeledDropdownField(
                            label: 'Supplier / Vendor',
                            required: true,
                            value: controller.supplierId.value,
                            options: suppliers,

                            onChanged: (v) => controller.supplierId.value = v,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New Supplier'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue.shade600,
                          side: BorderSide(color: Colors.blue.shade200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Purchase Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Bill / Invoice No.',
                          required: true,
                          controller: controller.billInvoiceNoController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => LabeledDateField(
                            label: 'Bill Date',
                            required: true,
                            value: controller.billDate.value,
                            onChanged: (v) => controller.billDate.value = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Batch / Lot No.',
                          controller: controller.batchLotController,
                          suffixIcon: Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => LabeledDateField(
                            label: 'Expiry Date',
                            placeholder: 'Optional',
                            value: controller.expiryDate.value,
                            onChanged: (v) => controller.expiryDate.value = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
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
                        child: LabeledTextField(
                          label: 'Purchase Price (₹)',
                          required: true,
                          controller: controller.purchasePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: controller.onPurchasePriceChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Discount (%)',
                          controller: controller.discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: controller.onDiscountChanged,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Obx(
                          () => LabeledDropdownField(
                            label: 'Tax (%)',
                            required: true,
                            value:
                                '${controller.taxPercent.value.toStringAsFixed(0)}%',
                            options: gstRates,

                            onChanged: (v) =>
                                controller.onTaxChanged(v!.replaceAll('%', '')),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => LabeledDropdownField(
                            label: 'Payment Method',
                            value: controller.paymentMethod.value,
                            options: paymentMethods,

                            onChanged: (v) =>
                                controller.paymentMethod.value = v,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => LabeledDateField(
                            label: 'Due Date',
                            value: controller.dueDate.value,
                            onChanged: (v) => controller.dueDate.value = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Notes',
                    hintText: 'Add any additional notes...',
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
                    child: ElevatedButton.icon(
                      onPressed: controller.savePurchase,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Save Purchase'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12B76A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
