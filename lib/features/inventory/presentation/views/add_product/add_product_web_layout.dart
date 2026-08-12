// import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/add_product_textfield.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/image_upload_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/product_dropdown.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/radio_tile.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProductWebLayout extends StatelessWidget {
  const AddProductWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    List<String> categories = Get.find<InventoryController>().categories
        .map((c) => c.name)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: ListView(
                      padding: const EdgeInsets.only(right: 28),
                      children: [
                        SectionCard(
                          title: 'Product Information',
                          subtitle: 'Basic details about the product',
                          icon: Icons.inventory_2_outlined,
                          children: [
                            const FieldLabel('Product Name', required: true),
                            AddProductTextfield(
                              controller: controller.productNameCtrl,
                              hint: 'e.g. Samsung 55" 4K QLED TV',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'Category',
                                        required: true,
                                      ),
                                      Obx(
                                        () => AddProductDropdown(
                                          hint: 'Select category',
                                          value:
                                              controller
                                                  .draftProduct
                                                  .value
                                                  .categoryId
                                                  .isEmpty
                                              ? null
                                              : controller
                                                    .draftProduct
                                                    .value
                                                    .categoryId,
                                          items: categories,
                                          onChanged: controller.updateCategory,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel('Brand'),
                                      AddProductTextfield(
                                        controller: controller.brandCtrl,
                                        hint: 'e.g. Samsung',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel('Supplier'),
                                      Obx(
                                        () => AddProductDropdown(
                                          hint: 'Select supplier',
                                          value: controller
                                              .draftProduct
                                              .value
                                              .primarySupplierId,
                                          items: suppliers,
                                          onChanged: controller.updateSupplier,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel('Unit'),
                                      Obx(
                                        () => AddProductDropdown(
                                          hint: 'Select unit',
                                          value:
                                              controller
                                                  .draftProduct
                                                  .value
                                                  .unitId
                                                  .isEmpty
                                              ? null
                                              : controller
                                                    .draftProduct
                                                    .value
                                                    .unitId,
                                          items: controller.units,
                                          onChanged: controller.updateUnit,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const FieldLabel('Description'),
                            AddProductTextfield(
                              controller: controller.descriptionCtrl,
                              hint: 'Product description (optional)',
                              maxLines: 4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Pricing',
                          subtitle: 'Set purchase and selling prices',
                          icon: Icons.payments_outlined,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'Purchase Price (₹)',
                                        required: true,
                                      ),
                                      AddProductTextfield(
                                        controller:
                                            controller.purchasePriceCtrl,
                                        hint: '0.00',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}'),
                                          ),
                                        ],
                                        prefixText: '₹ ',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'Selling Price (₹)',
                                        required: true,
                                      ),
                                      AddProductTextfield(
                                        controller: controller.sellingPriceCtrl,
                                        hint: '0.00',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}'),
                                          ),
                                        ],
                                        prefixText: '₹ ',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'MRP (₹)',
                                        info:
                                            'Maximum Retail Price printed on the package',
                                      ),
                                      AddProductTextfield(
                                        controller: controller.mrpCtrl,
                                        hint: '0.00',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        prefixText: '₹ ',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel('Wholesale Price (₹)'),
                                AddProductTextfield(
                                  controller: controller.wholesalePriceCtrl,
                                  hint: '0.00',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  prefixText: '₹ ',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Inventory',
                          subtitle: 'Stock levels and location',
                          icon: Icons.warehouse_outlined,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'Opening Stock',
                                        required: true,
                                      ),
                                      AddProductTextfield(
                                        controller: controller.openingStockCtrl,
                                        hint: '0',
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'Min. Stock Alert',
                                        info:
                                            'Alert when stock falls below this',
                                      ),
                                      AddProductTextfield(
                                        controller:
                                            controller.minStockAlertCtrl,
                                        hint: '5',
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const FieldLabel('Warehouse'),
                            Obx(
                              () => AddProductDropdown(
                                hint: 'Select warehouse',
                                value: controller.selectedWarehouse.value,
                                items: warehouses,
                                onChanged: controller.selectWarehouse,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Tax & GST',
                          subtitle: 'Tax rates applied to this product',
                          icon: Icons.receipt_long_outlined,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel(
                                        'GST Rate',
                                        required: true,
                                      ),
                                      Obx(
                                        () => AddProductDropdown(
                                          hint: 'Select GST rate',
                                          value: controller.gstLabel,
                                          items: gstRates,
                                          onChanged: controller.updateGST,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel('HSN Code'),
                                      AddProductTextfield(
                                        controller: controller.hsnCodeCtrl,
                                        hint: 'e.g. 8528720',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldLabel('Tax Inclusive'),
                                      Obx(
                                        () => Row(
                                          children: [
                                            Expanded(
                                              child: RadioTile(
                                                label: 'Exclusive',
                                                selected:
                                                    controller
                                                        .taxInclusive
                                                        .value ==
                                                    'Exclusive',
                                                onTap: () =>
                                                    controller.setTaxInclusive(
                                                      'Exclusive',
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: RadioTile(
                                                label: 'Inclusive',
                                                selected:
                                                    controller
                                                        .taxInclusive
                                                        .value ==
                                                    'Inclusive',
                                                onTap: () =>
                                                    controller.setTaxInclusive(
                                                      'Inclusive',
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Variants',
                          subtitle:
                              'Add product variants like Size, Color, etc.',
                          icon: Icons.tune_outlined,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AddProductTextfield(
                                    controller: controller.variantNameCtrl,
                                    hint: 'Variant name (e.g. Color)',
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 2,
                                  child: AddProductTextfield(
                                    controller: controller.variantValuesCtrl,
                                    hint:
                                        'Values (comma-separated, e.g. Black, White, Silver)',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            InkWell(
                              onTap: controller.addVariant,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.add_circle_outline,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Add Variant',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () =>
                                  controller.draftProduct.value.variants.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: controller
                                            .draftProduct
                                            .value
                                            .variants
                                            .map(
                                              (v) => Chip(
                                                label: Text(
                                                  v.attributes
                                                      .map(
                                                        (a) =>
                                                            '${a.name}: ${a.value}',
                                                      )
                                                      .join(', '),
                                                ),
                                                onDeleted: () => controller
                                                    .removeVariant(v.id),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          title: 'Internal Notes',
                          subtitle:
                              'Only visible to your team, not on invoices',
                          icon: Icons.sticky_note_2_outlined,
                          children: [
                            AddProductTextfield(
                              controller: controller.internalNotesCtrl,
                              hint: 'Internal notes (not visible on invoice)',
                              maxLines: 4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              SectionCard(
                                title: 'Product Images',
                                subtitle: 'Add up to 5 images for this product',
                                icon: Icons.image_outlined,
                                children: [
                                  ImageUploadGrid(
                                    onUpload: () {},
                                    controller: controller,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SectionCard(
                                title: 'Barcode & Identifiers',
                                subtitle:
                                    'Scan, generate or assign product codes',
                                icon: Icons.qr_code_2_outlined,
                                children: [
                                  const FieldLabel('Barcode (EAN/UPC)'),
                                  AddProductTextfield(
                                    controller: controller.barcodeCtrl,
                                    hint: 'Scan or enter barcode',
                                    suffixIcon: Icons.qr_code_scanner_outlined,
                                    onSuffixTap: () {},
                                  ),
                                  const SizedBox(height: 18),
                                  const FieldLabel('SKU'),
                                  AddProductTextfield(
                                    controller: controller.skuCtrl,
                                    hint: 'e.g. SAM-TV-55Q',
                                  ),
                                  const SizedBox(height: 18),
                                  const FieldLabel('Barcode Type'),
                                  Obx(
                                    () => AddProductDropdown(
                                      hint: 'Select barcode type',
                                      value:
                                          controller.selectedBarcodeType.value,
                                      items: barcodeTypes,
                                      onChanged: controller.selectBarcodeType,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildActionCard(context, controller),
                      ],
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

  Widget _buildTopBar(BuildContext context) {
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
          Text(
            'New Product',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    AddProductController controller,
  ) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : controller.addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: controller.isSaving.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Add Product',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : controller.saveDraft,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save as Draft',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: controller.isSaving.value ? null : controller.cancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
