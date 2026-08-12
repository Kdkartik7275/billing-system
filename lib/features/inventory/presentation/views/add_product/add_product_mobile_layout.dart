import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/add_product_textfield.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/bottom_bar.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/image_upload_grid.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/product_dropdown.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/radio_tile.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProductMobileLayout extends StatelessWidget {
  const AddProductMobileLayout({super.key});

  Future<void> _pickAndAddImage(AddProductController controller) async {
    final file = await pickImage();
    if (file == null) return;
    controller.addImage(
      file.path,
      isPrimary: controller.draftProduct.value.images.isEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Scaffold(
      appBar: _buildAppBar(context, controller),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                const SizedBox(height: 18),
                const FieldLabel('Category', required: true),
                Obx(
                  () => AddProductDropdown(
                    hint: 'Select category',
                    value: controller.draftProduct.value.categoryId.isEmpty
                        ? null
                        : controller.draftProduct.value.categoryId,
                    items: controller.categories,
                    onChanged: controller.updateCategory,
                  ),
                ),
                const SizedBox(height: 18),
                const FieldLabel('Brand'),
                AddProductTextfield(
                  controller: controller.brandCtrl,
                  hint: 'e.g. Samsung',
                ),
                const SizedBox(height: 18),
                const FieldLabel('Supplier'),
                Obx(
                  () => AddProductDropdown(
                    hint: 'Select supplier',
                    value: controller.draftProduct.value.primarySupplierId,
                    items: suppliers,
                    onChanged: controller.updateSupplier,
                  ),
                ),
                const SizedBox(height: 18),
                const FieldLabel('Unit'),
                Obx(
                  () => AddProductDropdown(
                    hint: 'Select unit',
                    value: controller.draftProduct.value.unitId.isEmpty
                        ? null
                        : controller.draftProduct.value.unitId,
                    items: controller.units,
                    onChanged: controller.updateUnit,
                  ),
                ),
                const SizedBox(height: 18),
                const FieldLabel('Description'),
                AddProductTextfield(
                  controller: controller.descriptionCtrl,
                  hint: 'Product description (optional)',
                  maxLines: 4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Pricing',
              subtitle: 'Set purchase and selling prices',
              icon: Icons.payments_outlined,
              children: [
                const FieldLabel('Purchase Price (₹)', required: true),
                AddProductTextfield(
                  controller: controller.purchasePriceCtrl,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  prefixText: '₹ ',
                ),
                const SizedBox(height: 18),
                const FieldLabel('Selling Price (₹)', required: true),
                AddProductTextfield(
                  controller: controller.sellingPriceCtrl,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  prefixText: '₹ ',
                ),
                const SizedBox(height: 18),
                const FieldLabel(
                  'MRP (₹)',
                  info: 'Maximum Retail Price printed on the package',
                ),
                AddProductTextfield(
                  controller: controller.mrpCtrl,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixText: '₹ ',
                ),
                const SizedBox(height: 18),
                const FieldLabel('Wholesale Price (₹)'),
                AddProductTextfield(
                  controller: controller.wholesalePriceCtrl,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixText: '₹ ',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Inventory',
              subtitle: 'Stock levels and location',
              icon: Icons.warehouse_outlined,
              children: [
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('Opening Stock', required: true),
                          AddProductTextfield(
                            controller: controller.openingStockCtrl,
                            hint: '0',

                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel(
                            'Min. Stock Alert',
                            info: 'Alert when stock falls below this',
                          ),
                          AddProductTextfield(
                            controller: controller.minStockAlertCtrl,
                            hint: '5',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
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
            const SizedBox(height: 16),
            SectionCard(
              title: 'Tax & GST',
              subtitle: 'Tax rates applied to this product',
              icon: Icons.receipt_long_outlined,
              children: [
                const FieldLabel('GST Rate', required: true),
                Obx(
                  () => AddProductDropdown(
                    hint: 'Select GST rate',
                    value: controller.gstLabel,
                    items: gstRates,
                    onChanged: controller.updateGST,
                  ),
                ),
                const SizedBox(height: 18),
                const FieldLabel('HSN Code'),
                AddProductTextfield(
                  controller: controller.hsnCodeCtrl,
                  hint: 'e.g. 8528720',
                ),
                const SizedBox(height: 18),
                const FieldLabel('Tax Inclusive'),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioTile(
                          label: 'Exclusive',
                          selected:
                              controller.taxInclusive.value == 'Exclusive',
                          onTap: () => controller.setTaxInclusive('Exclusive'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RadioTile(
                          label: 'Inclusive',
                          selected:
                              controller.taxInclusive.value == 'Inclusive',
                          onTap: () => controller.setTaxInclusive('Inclusive'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Barcode & Identifiers',
              subtitle: 'Scan, generate or assign product codes',
              icon: Icons.qr_code_2_outlined,
              children: [
                const FieldLabel('Barcode (EAN/UPC)'),
                AddProductTextfield(
                  controller: controller.barcodeCtrl,
                  hint: 'Scan or enter barcode',
                  suffixIcon: Icons.qr_code_scanner_outlined,
                  onSuffixTap: controller.scanBarcode,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => printBarcode(controller.barcodeCtrl.text),
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print Barcode'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const FieldLabel('SKU'),
                AddProductTextfield(
                  readOnly: true,
                  controller: controller.skuCtrl,
                  hint: 'Auto-generated from name and category',
                ),
                const SizedBox(height: 18),
                const FieldLabel('Barcode Type'),
                Obx(
                  () => AddProductDropdown(
                    hint: 'Select barcode type',
                    value: controller.selectedBarcodeType.value,
                    items: barcodeTypes,
                    onChanged: controller.selectBarcodeType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Product Images',
              subtitle: 'Add up to 5 images for this product',
              icon: Icons.image_outlined,
              children: [
                ImageUploadGrid(
                  controller: controller,
                  onUpload: () => _pickAndAddImage(controller),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Variants',
              subtitle: 'Add product variants like Size, Color, etc.',
              icon: Icons.tune_outlined,
              children: [
                AddProductTextfield(
                  controller: controller.variantNameCtrl,
                  hint: 'Variant name (e.g. Color)',
                ),
                const SizedBox(height: 12),
                AddProductTextfield(
                  controller: controller.variantValuesCtrl,
                  hint: 'Values (comma-separated, e.g. Black, White, Silver)',
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: controller.addVariant,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
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
                  () => controller.draftProduct.value.variants.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.draftProduct.value.variants
                                .map(
                                  (v) => Chip(
                                    label: Text(
                                      v.attributes
                                          .map((a) => '${a.name}: ${a.value}')
                                          .join(', '),
                                    ),
                                    onDeleted: () =>
                                        controller.removeVariant(v.id),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Internal Notes',
              subtitle: 'Only visible to your team, not on invoices',
              icon: Icons.sticky_note_2_outlined,
              children: [
                AddProductTextfield(
                  controller: controller.internalNotesCtrl,
                  hint: 'Internal notes (not visible on invoice)',
                  maxLines: 4,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: ProductActionButtons(controller: controller),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AddProductController controller,
  ) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Text(
        controller.isEditMode ? 'Edit Product' : 'New Product',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}
