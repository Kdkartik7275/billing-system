import 'package:billing_system/core/config/constants/dropdown_values.dart';
import 'package:billing_system/core/helper/functions.dart' as scanner;
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';

import 'package:billing_system/features/inventory/domain/usecases/product/add_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/update_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_image.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_price.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_settings.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_tax.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_variant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddProductController extends GetxController {
  AddProductController({
    required this.addProductUseCase,
    this.updateProductUseCase,
    this.initialProduct,
    this.initialStockEntry,
  });

  // ---------------- DEPENDENCIES ----------------

  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase? updateProductUseCase;
  final ProductEntity? initialProduct;
  final StockEntity? initialStockEntry;
  final Uuid _uuid = const Uuid();

  final InventoryController _inventoryController =
      Get.find<InventoryController>();

  bool get isEditMode => initialProduct != null;

  // ---------------- STATE ----------------

  late final Rx<ProductEntity> draftProduct;

  final RxBool isSaving = false.obs;
  final RxnString errorMessage = RxnString();

  bool _skuManuallyEdited = false;
  bool _isAutoFillingSku = false;

  // ---------------- TEXT CONTROLLERS ----------------

  final TextEditingController productNameCtrl = TextEditingController();
  final TextEditingController brandCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController purchasePriceCtrl = TextEditingController();
  final TextEditingController sellingPriceCtrl = TextEditingController();
  final TextEditingController mrpCtrl = TextEditingController();
  final TextEditingController wholesalePriceCtrl = TextEditingController();

  final TextEditingController openingStockCtrl = TextEditingController();
  final TextEditingController minStockAlertCtrl = TextEditingController();

  final TextEditingController hsnCodeCtrl = TextEditingController();
  final TextEditingController barcodeCtrl = TextEditingController();
  final TextEditingController skuCtrl = TextEditingController();

  final TextEditingController variantNameCtrl = TextEditingController();
  final TextEditingController variantValuesCtrl = TextEditingController();
  final TextEditingController internalNotesCtrl = TextEditingController();

  // ---------------- UI SELECTION STATE ----------------

  final RxString selectedWarehouse = 'Main Store'.obs;
  final RxString selectedBarcodeType = 'EAN-13'.obs;
  final RxString taxInclusive = 'Exclusive'.obs;
  final RxnString selectedCategory = RxnString();
  final RxnString selectedUnit = RxnString();

  List<String> get categories =>
      _inventoryController.categories.map((c) => c.name).toList();

  List<String> get units =>
      _inventoryController.units.map((c) => c.name).toList();

  // ---------------- LIFECYCLE ----------------

  @override
  void onInit() {
    super.onInit();
    if (initialProduct != null) {
      draftProduct = initialProduct!.obs;
      _prefillFromProduct(initialProduct!, initialStockEntry!);
      _skuManuallyEdited = true;
    } else {
      draftProduct = _buildEmptyDraft().obs;
    }
    _bindTextControllers();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    brandCtrl.dispose();
    descriptionCtrl.dispose();
    purchasePriceCtrl.dispose();
    sellingPriceCtrl.dispose();
    mrpCtrl.dispose();
    wholesalePriceCtrl.dispose();
    openingStockCtrl.dispose();
    minStockAlertCtrl.dispose();
    hsnCodeCtrl.dispose();
    barcodeCtrl.dispose();
    skuCtrl.dispose();
    variantNameCtrl.dispose();
    variantValuesCtrl.dispose();
    internalNotesCtrl.dispose();
    super.onClose();
  }

  // ---------------- EDIT MODE PREFILL ----------------

  void _prefillFromProduct(ProductEntity p, StockEntity s) {
    productNameCtrl.text = p.name;
    brandCtrl.text =
        _inventoryController.brandName(p.brandId) ?? p.brandId ?? '';
    descriptionCtrl.text = p.description ?? '';
    purchasePriceCtrl.text = p.price.purchasePrice.toStringAsFixed(2);
    sellingPriceCtrl.text = p.price.sellingPrice.toStringAsFixed(2);
    mrpCtrl.text = p.price.mrp?.toStringAsFixed(2) ?? '';
    wholesalePriceCtrl.text = p.price.wholesalePrice?.toStringAsFixed(2) ?? '';
    openingStockCtrl.text = s.quantity.toStringAsFixed(0);
    hsnCodeCtrl.text = p.tax.hsnCode ?? '';
    barcodeCtrl.text = p.barcode;
    skuCtrl.text = p.sku;
    minStockAlertCtrl.text = p.settings.lowStockThreshold.toString();

    taxInclusive.value = p.tax.type == TaxType.inclusive
        ? 'Inclusive'
        : 'Exclusive';

    final matchedUnit = _inventoryController.units
        .where((u) => u.id == p.unitId)
        .firstOrNull;
    selectedUnit.value = matchedUnit?.name;

    final matchedCategory = _inventoryController.categories
        .where((c) => c.id == p.categoryId)
        .firstOrNull;
    selectedCategory.value = matchedCategory?.name;
  }

  // ---------------- TEXT FIELD BINDINGS ----------------

  void _bindTextControllers() {
    productNameCtrl.addListener(() => updateProductName(productNameCtrl.text));
    brandCtrl.addListener(
      () => updateBrand(brandCtrl.text.isEmpty ? null : brandCtrl.text),
    );
    descriptionCtrl.addListener(() => updateDescription(descriptionCtrl.text));
    purchasePriceCtrl.addListener(
      () => updatePurchasePrice(purchasePriceCtrl.text),
    );
    sellingPriceCtrl.addListener(
      () => updateSellingPrice(sellingPriceCtrl.text),
    );
    mrpCtrl.addListener(() => updateMRP(mrpCtrl.text));
    wholesalePriceCtrl.addListener(
      () => updateWholesalePrice(wholesalePriceCtrl.text),
    );
    hsnCodeCtrl.addListener(() => updateHSN(hsnCodeCtrl.text));
    barcodeCtrl.addListener(() => updateBarcode(barcodeCtrl.text));
    skuCtrl.addListener(() {
      if (!_isAutoFillingSku) {
        _skuManuallyEdited = skuCtrl.text.trim().isNotEmpty;
      }
      updateSKU(skuCtrl.text);
    });
    minStockAlertCtrl.addListener(
      () => updateLowStockThreshold(minStockAlertCtrl.text),
    );
  }

  // ---------------- DRAFT BUILDER ----------------

  ProductEntity _buildEmptyDraft() {
    final now = DateTime.now();
    return ProductEntity(
      id: _uuid.v4(),
      name: '',
      description: null,
      sku: '',
      barcode: '',
      categoryId: '',
      brandId: null,
      unitId: '',
      primarySupplierId: null,
      price: const ProductPrice(
        purchasePrice: 0,
        sellingPrice: 0,
        mrp: null,
        wholesalePrice: null,
      ),
      tax: const ProductTax(
        gstPercent: 0,
        type: TaxType.exclusive,
        hsnCode: null,
      ),
      settings: const ProductSettings(),
      variants: const [],
      images: const [],
      createdAt: now,
      updatedAt: null,
    );
  }

  // ---------------- SKU AUTO-GENERATION ----------------

  void _autoGenerateSku() {
    if (_skuManuallyEdited) return;

    final name = productNameCtrl.text.trim();
    if (name.isEmpty) return;

    final categoryRaw = (selectedCategory.value ?? '').replaceAll(
      RegExp(r'[^A-Za-z]'),
      '',
    );
    final categoryCode = categoryRaw.toUpperCase();
    final categoryPart = categoryCode.isEmpty
        ? ''
        : categoryCode.substring(
            0,
            categoryCode.length < 3 ? categoryCode.length : 3,
          );

    final nameRaw = name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final namePart = nameRaw.isEmpty
        ? ''
        : nameRaw
              .substring(0, nameRaw.length < 6 ? nameRaw.length : 6)
              .toUpperCase();

    final idDigits = draftProduct.value.id.replaceAll('-', '').toUpperCase();
    final idSuffix = idDigits.isEmpty
        ? ''
        : idDigits.substring(idDigits.length < 4 ? 0 : idDigits.length - 4);

    final generated = [
      categoryPart,
      namePart,
      idSuffix,
    ].where((p) => p.isNotEmpty).join('-');

    if (generated.isEmpty) return;

    _isAutoFillingSku = true;
    skuCtrl.text = generated;
    _isAutoFillingSku = false;
    updateSKU(generated);
  }

  // ---------------- BARCODE ACTIONS ----------------

  Future<void> scanBarcode() async {
    final result = await scanner.scanBarcode(title: 'Scan Product Barcode');
    if (result == null) return;
    barcodeCtrl.text = result;
  }

  // ---------------- SELECTORS ----------------

  void setTaxInclusive(String label) {
    taxInclusive.value = label;
    updateTaxType(label);
  }

  void selectWarehouse(String? warehouse) {
    if (warehouse == null) return;
    selectedWarehouse.value = warehouse;
  }

  void selectBarcodeType(String? type) {
    if (type == null) return;
    selectedBarcodeType.value = type;
  }

  String get gstLabel {
    final p = draftProduct.value.tax.gstPercent;
    final formatted = p == p.roundToDouble()
        ? p.toInt().toString()
        : p.toString();
    return '$formatted%';
  }

  // ---------------- BASIC FIELD UPDATES ----------------

  void updateProductName(String value) {
    final updated = draftProduct.value.copyWith(name: value);

    draftProduct.value = updated;
    _autoGenerateSku();
  }

  void updateDescription(String value) {
    draftProduct.value = draftProduct.value.copyWith(
      description: value.isEmpty ? null : value,
    );
  }

  void updateBrand(String? brandId) {
    draftProduct.value = draftProduct.value.copyWith(brandId: brandId);
  }

  void updateCategory(String? categoryId) {
    draftProduct.value = draftProduct.value.copyWith(
      categoryId: categoryId ?? '',
    );
  }

  void updateSupplier(String? supplierId) {
    draftProduct.value = draftProduct.value.copyWith(
      primarySupplierId: supplierId,
    );
  }

  void updateUnit(String? unitId) {
    if (unitId == null) return;
    draftProduct.value = draftProduct.value.copyWith(unitId: unitId);
  }

  void updateSKU(String value) {
    draftProduct.value = draftProduct.value.copyWith(sku: value);
  }

  void updateBarcode(String value) {
    draftProduct.value = draftProduct.value.copyWith(barcode: value);
  }

  // ---------------- PRICING UPDATES ----------------

  void updatePurchasePrice(String value) {
    final parsed =
        double.tryParse(value) ?? draftProduct.value.price.purchasePrice;
    final updatedPrice = draftProduct.value.price.copyWith(
      purchasePrice: parsed,
    );
    draftProduct.value = draftProduct.value.copyWith(price: updatedPrice);
  }

  void updateSellingPrice(String value) {
    final parsed =
        double.tryParse(value) ?? draftProduct.value.price.sellingPrice;
    final updatedPrice = draftProduct.value.price.copyWith(
      sellingPrice: parsed,
    );
    draftProduct.value = draftProduct.value.copyWith(price: updatedPrice);
  }

  void updateMRP(String value) {
    final parsed = value.isEmpty ? null : double.tryParse(value);
    final updatedPrice = draftProduct.value.price.copyWith(mrp: parsed);
    draftProduct.value = draftProduct.value.copyWith(price: updatedPrice);
  }

  void updateWholesalePrice(String value) {
    final parsed = value.isEmpty ? null : double.tryParse(value);
    final updatedPrice = draftProduct.value.price.copyWith(
      wholesalePrice: parsed,
    );
    draftProduct.value = draftProduct.value.copyWith(price: updatedPrice);
  }

  // ---------------- TAX UPDATES ----------------

  void updateGST(String? gstLabel) {
    if (gstLabel == null) return;
    final parsed = double.tryParse(gstLabel.replaceAll('%', '')) ?? 0;
    final updatedTax = draftProduct.value.tax.copyWith(gstPercent: parsed);
    draftProduct.value = draftProduct.value.copyWith(tax: updatedTax);
  }

  void updateTaxType(String taxInclusiveLabel) {
    final type = taxInclusiveLabel.toLowerCase() == 'inclusive'
        ? TaxType.inclusive
        : TaxType.exclusive;
    final updatedTax = draftProduct.value.tax.copyWith(type: type);
    draftProduct.value = draftProduct.value.copyWith(tax: updatedTax);
  }

  void updateHSN(String value) {
    final updatedTax = draftProduct.value.tax.copyWith(
      hsnCode: value.isEmpty ? null : value,
    );
    draftProduct.value = draftProduct.value.copyWith(tax: updatedTax);
  }

  // ---------------- SETTINGS UPDATES ----------------

  void updateLowStockThreshold(String value) {
    final parsed =
        int.tryParse(value) ?? draftProduct.value.settings.lowStockThreshold;
    final updatedSettings = draftProduct.value.settings.copyWith(
      lowStockThreshold: parsed,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  void updateNegativeStock(bool value) {
    final updatedSettings = draftProduct.value.settings.copyWith(
      allowNegativeStock: value,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  void updateIsActive(bool value) {
    final updatedSettings = draftProduct.value.settings.copyWith(
      isActive: value,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  void updateTrackBatch(bool value) {
    final updatedSettings = draftProduct.value.settings.copyWith(
      trackBatches: value,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  void updateTrackExpiry(bool value) {
    final updatedSettings = draftProduct.value.settings.copyWith(
      trackExpiry: value,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  void updateLoyaltyEligible(bool value) {
    final updatedSettings = draftProduct.value.settings.copyWith(
      isLoyaltyEligible: value,
    );
    draftProduct.value = draftProduct.value.copyWith(settings: updatedSettings);
  }

  // ---------------- VARIANTS ----------------

  void addVariant() {
    final name = variantNameCtrl.text.trim();
    final valuesRaw = variantValuesCtrl.text.trim();

    if (name.isEmpty || valuesRaw.isEmpty) {
      AppSnackbar.error(message: 'Enter a variant name and at least one value');
      return;
    }

    final values = valuesRaw
        .split(',')
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toList();

    if (values.isEmpty) {
      AppSnackbar.error(message: 'Enter at least one value');
      return;
    }

    final existingCount = draftProduct.value.variants.length;
    final newVariants = <ProductVariant>[];
    for (var i = 0; i < values.length; i++) {
      newVariants.add(
        ProductVariant(
          id: _uuid.v4(),
          sku: '${draftProduct.value.sku}-${existingCount + i + 1}',
          barcode: null,
          attributes: [VariantAttribute(name: name, value: values[i])],
          sellingPriceOverride: null,
          isActive: true,
        ),
      );
    }

    draftProduct.value = draftProduct.value.copyWith(
      variants: [...draftProduct.value.variants, ...newVariants],
    );

    variantNameCtrl.clear();
    variantValuesCtrl.clear();
  }

  void removeVariant(String variantId) {
    final updatedVariants = draftProduct.value.variants
        .where((v) => v.id != variantId)
        .toList();
    draftProduct.value = draftProduct.value.copyWith(variants: updatedVariants);
  }

  // ---------------- IMAGES ----------------

  void addImage(String url, {bool isPrimary = false, String? altText}) {
    final newImage = ProductImage(
      url: url,
      isPrimary: isPrimary,
      altText: altText,
    );
    final updatedImages = [...draftProduct.value.images, newImage];
    draftProduct.value = draftProduct.value.copyWith(images: updatedImages);
  }

  void removeImage(String url) {
    final updatedImages = draftProduct.value.images
        .where((img) => img.url != url)
        .toList();
    draftProduct.value = draftProduct.value.copyWith(images: updatedImages);
  }

  // ---------------- SAVE ACTIONS ----------------

  Future<void> addProduct() async {
    if (isSaving.value) return;

    errorMessage.value = null;

    if (draftProduct.value.name.trim().isEmpty) {
      errorMessage.value = 'Product name is required';
      return;
    }
    if (draftProduct.value.categoryId.trim().isEmpty) {
      errorMessage.value = 'Please select a category';
      return;
    }

    isSaving.value = true;
    try {
      String categoryId = _inventoryController.categories
          .firstWhere((c) => c.name == draftProduct.value.categoryId)
          .id;
      String unitId = _inventoryController.units
          .firstWhere((c) => c.name == draftProduct.value.unitId)
          .id;

      final product = draftProduct.value.copyWith(
        updatedAt: DateTime.now(),
        categoryId: categoryId,
        unitId: unitId,
      );

      final result = await addProductUseCase.call(
        AddProductParams(
          product: product,
          openingStock: double.tryParse(openingStockCtrl.text) ?? 0,
        ),
      );
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          debugPrint(err.message);
        },
        (pr) {
          Get.back(result: pr);
          AppSnackbar.success(message: 'Product added successfully');
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to save product: ${e.toString()}';
      debugPrint(e.toString());
      Get.snackbar('Error', errorMessage.value!);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateProduct() async {
    if (isSaving.value) return;

    errorMessage.value = null;

    if (draftProduct.value.name.trim().isEmpty) {
      errorMessage.value = 'Product name is required';
      return;
    }
    if (draftProduct.value.categoryId.trim().isEmpty) {
      errorMessage.value = 'Please select a category';
      return;
    }
    if (updateProductUseCase == null) {
      errorMessage.value = 'Update is not available right now';
      AppSnackbar.error(message: errorMessage.value!);
      return;
    }

    isSaving.value = true;
    try {
      String categoryId = _inventoryController.categories
          .firstWhere((c) => c.name == draftProduct.value.categoryId)
          .id;
      String unitId = _inventoryController.units
          .firstWhere((c) => c.name == draftProduct.value.unitId)
          .id;
      final product = draftProduct.value.copyWith(
        updatedAt: DateTime.now(),
        categoryId: categoryId,
        unitId: unitId,
      );

      final result = await updateProductUseCase!.call(product);
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          debugPrint(err.message);
        },
        (pr) {
          Get.back(result: pr);
          AppSnackbar.success(message: 'Product updated successfully');
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to update product: ${e.toString()}';
      debugPrint(e.toString());
      Get.snackbar('Error', errorMessage.value!);
    } finally {
      isSaving.value = false;
    }
  }

  void deleteProduct() {
    if (!isEditMode) return;
    Get.find<InventoryController>().deleteProduct(draftProduct.value.id);
    Get.back();
  }

  Future<void> saveDraft() async {}

  void cancel() => Get.back();
}
