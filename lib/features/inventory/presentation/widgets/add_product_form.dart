import 'dart:io';
import 'package:billing_system/core/config/constants/categories.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/core/helper/generate_sku.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/form_fields.dart';
import 'package:billing_system/features/inventory/presentation/widgets/image_upload_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductForm extends StatefulWidget {
  final String? initialBarcode;
  const AddProductForm({super.key, this.initialBarcode});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _controller = Get.find<InventoryController>();

  File? _pickedImage;
  String? _selectedCategory;
  String? _selectedUnit;

  final _nameCtrl = TextEditingController();
  late final TextEditingController _barcodeCtrl;
  final _priceCtrl = TextEditingController();
  final _purchasePriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _supplierCtrl = TextEditingController();

  // Per-field error messages
  String? _nameError;
  String? _priceError;
  String? _purchasePriceError;
  String? _stockError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: widget.initialBarcode ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _barcodeCtrl.dispose();
    _priceCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _stockCtrl.dispose();
    _supplierCtrl.dispose();
    super.dispose();
  }

  // ── Image picker ────────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () async {
                final img = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                Get.back(result: img);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () async {
                final img = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                Get.back(result: img);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) {
      setState(() => _pickedImage = File(result.path));
    }
  }

  bool _validate() {
    String? nameErr, priceErr, purchasePriceErr, stockErr, catErr;

    if (_nameCtrl.text.trim().isEmpty) {
      nameErr = 'Product name is required';
    }
    if (_selectedCategory == null) {
      catErr = 'Please select a category';
    }
    final price = double.tryParse(_priceCtrl.text.trim());
    if (_priceCtrl.text.trim().isEmpty || price == null || price < 0) {
      priceErr = 'Enter a valid price';
    }
    final purchasePrice = double.tryParse(_purchasePriceCtrl.text.trim());
    if (_purchasePriceCtrl.text.trim().isEmpty ||
        purchasePrice == null ||
        purchasePrice < 0) {
      purchasePriceErr = 'Enter a valid purchase price';
    }
    final stock = int.tryParse(_stockCtrl.text.trim());
    if (_stockCtrl.text.trim().isEmpty || stock == null || stock < 0) {
      stockErr = 'Enter a valid stock qty';
    }

    setState(() {
      _nameError = nameErr;
      _categoryError = catErr;
      _priceError = priceErr;
      _purchasePriceError = purchasePriceErr;
      _stockError = stockErr;
    });

    return nameErr == null &&
        catErr == null &&
        priceErr == null &&
        purchasePriceErr == null &&
        stockErr == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final sku = generateSku(
      category: _selectedCategory!,
      productName: _nameCtrl.text.trim(),
      sequence: getNextSkuSequence(_selectedCategory!, _controller.products),
    );

    final product = InventoryProduct(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      sku: sku,
      barcode: _barcodeCtrl.text.trim(),
      category: _selectedCategory!,
      price: double.parse(_priceCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      stockUnit: _selectedUnit ?? 'piece',
      supplier: _supplierCtrl.text.trim(),
      imageUrl: '',
      purchasePrice: double.parse(_purchasePriceCtrl.text.trim()),
    );

    Get.back();

    await _controller.addProduct(product, imageFile: _pickedImage);
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSubmitting = _controller.addingNewProduct.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add new product',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fill in the details below',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: isSubmitting ? null : () => Get.back(),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploadTile(
                    image: _pickedImage,
                    onTap: _pickImage,
                    onRemove: () => setState(() => _pickedImage = null),
                  ),
                  const SizedBox(height: 18),

                  // Name + SKU
                  FormRow(
                    children: [
                      FormTextField(
                        label: 'Product Name *',
                        hint: 'e.g. Amul Milk',
                        controller: _nameCtrl,
                        errorText: _nameError,
                        onChanged: (_) => setState(() => _nameError = null),
                      ),
                      // FormTextField(
                      //   label: 'SKU',
                      //   hint: 'e.g. DY-MLK-002',
                      //   controller: _skuCtrl,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Barcode + Category
                  FormRow(
                    children: [
                      FormTextField(
                        label: 'Barcode',
                        hint: '8901234567891',
                        controller: _barcodeCtrl,
                      ),
                      FormDropdownField(
                        label: 'Category *',
                        hint: 'Select',
                        value: _selectedCategory,
                        errorText: _categoryError,
                        items: productCategories
                            .where((c) => c != 'All')
                            .toList(),
                        onChanged: (v) => setState(() {
                          _selectedCategory = v;
                          _categoryError = null;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price + Purchase Price
                  FormRow(
                    children: [
                      FormTextField(
                        label: 'Selling Price (₹) *',
                        hint: '0.00',
                        controller: _priceCtrl,
                        isNumber: true,
                        prefix: '₹',
                        errorText: _priceError,
                        onChanged: (_) => setState(() => _priceError = null),
                      ),
                      FormTextField(
                        label: 'Purchase Price (₹) *',
                        hint: '0.00',
                        controller: _purchasePriceCtrl,
                        isNumber: true,
                        prefix: '₹',
                        errorText: _purchasePriceError,
                        onChanged: (_) =>
                            setState(() => _purchasePriceError = null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Stock qty + Unit
                  FormRow(
                    children: [
                      FormTextField(
                        label: 'Stock qty *',
                        hint: '0',
                        controller: _stockCtrl,
                        isNumber: true,
                        errorText: _stockError,
                        onChanged: (_) => setState(() => _stockError = null),
                      ),
                      FormDropdownField(
                        label: 'Stock Unit',
                        hint: 'Select',
                        value: _selectedUnit,
                        items: kStockUnits,
                        onChanged: (v) => setState(() => _selectedUnit = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Supplier
                  FormTextField(
                    label: 'Supplier',
                    hint: 'Supplier name',
                    controller: _supplierCtrl,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Footer buttons ─────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
