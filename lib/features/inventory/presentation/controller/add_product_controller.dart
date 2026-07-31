import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';

import 'package:billing_system/features/inventory/domain/usecases/product/add_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_image.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_price.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_settings.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_tax.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_variant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddProductController extends GetxController {
  AddProductController({required this.addProductUseCase});

  final AddProductUseCase addProductUseCase;
  final Uuid _uuid = const Uuid();

  final InventoryController _inventoryController =
      Get.find<InventoryController>();

  late final Rx<ProductEntity> draftProduct;

  final RxBool isSaving = false.obs;
  final RxnString errorMessage = RxnString();

  final TextEditingController productNameCtrl = TextEditingController();
  final TextEditingController brandCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController purchasePriceCtrl = TextEditingController();
  final TextEditingController sellingPriceCtrl = TextEditingController();
  final TextEditingController mrpCtrl = TextEditingController();
  final TextEditingController wholesalePriceCtrl = TextEditingController();
  final TextEditingController minSellingPriceCtrl = TextEditingController();

  final TextEditingController openingStockCtrl = TextEditingController();
  final TextEditingController minStockAlertCtrl = TextEditingController();
  final TextEditingController maxStockCtrl = TextEditingController();
  final TextEditingController rackLocationCtrl = TextEditingController();

  final TextEditingController hsnCodeCtrl = TextEditingController();
  final TextEditingController barcodeCtrl = TextEditingController();
  final TextEditingController skuCtrl = TextEditingController();

  final TextEditingController variantNameCtrl = TextEditingController();
  final TextEditingController variantValuesCtrl = TextEditingController();
  final TextEditingController internalNotesCtrl = TextEditingController();

  final RxString selectedWarehouse = 'Main Store'.obs;
  final RxString selectedBarcodeType = 'EAN-13'.obs;
  final RxString taxInclusive = 'Exclusive'.obs;

  List<String> get categories =>
      _inventoryController.categories.map((c) => c.name).toList();

  final List<String> suppliers = const [
    'Samsung India Pvt Ltd',
    'Reliance Digital',
    'Local Distributor Co.',
    'Global Traders Inc.',
  ];

  final List<String> units = const [
    'Piece',
    'Box',
    'Kg',
    'Litre',
    'Pack',
    'Dozen',
  ];

  final List<String> warehouses = const [
    'Main Store',
    'Warehouse A',
    'Warehouse B',
  ];

  final List<String> gstRates = const ['0%', '5%', '12%', '18%', '28%'];

  final List<String> barcodeTypes = const [
    'EAN-13',
    'UPC-A',
    'CODE-128',
    'QR Code',
  ];

  @override
  void onInit() {
    super.onInit();
    draftProduct = _buildEmptyDraft().obs;
    _bindTextControllers();
  }

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
    skuCtrl.addListener(() => updateSKU(skuCtrl.text));
    minStockAlertCtrl.addListener(
      () => updateLowStockThreshold(minStockAlertCtrl.text),
    );
  }

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
      unitId: units.first,
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

  void updateProductName(String value) {
    final updated = draftProduct.value.copyWith(name: value);

    draftProduct.value = updated;
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

  void updateGST(String? gstLabel) {
    if (gstLabel == null) return;
    final parsed = double.tryParse(gstLabel.replaceAll('%', '')) ?? 0;
    final updatedTax = draftProduct.value.tax.copyWith(gstPercent: parsed);
    draftProduct.value = draftProduct.value.copyWith(tax: updatedTax);
  }

  void updateTaxType(String taxInclusiveLabel) {
    final type = taxInclusiveLabel.toLowerCase() == 'inclusive'
        ? TaxType
              .inclusive // ASSUMPTION: enum name
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

  void addVariant() {
    final name = variantNameCtrl.text.trim();
    final valuesRaw = variantValuesCtrl.text.trim();
    if (name.isEmpty || valuesRaw.isEmpty) return;

    final attributes = valuesRaw
        .split(',')
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .map((v) => VariantAttribute(name: name, value: v))
        .toList();

    final newVariant = ProductVariant(
      id: _uuid.v4(),
      sku: skuCtrl.text.trim().isEmpty
          ? '${draftProduct.value.sku}-${draftProduct.value.variants.length + 1}'
          : skuCtrl.text.trim(),
      barcode: null,
      attributes: attributes,
      sellingPriceOverride: null,
      isActive: true,
    );

    final updatedVariants = [...draftProduct.value.variants, newVariant];
    draftProduct.value = draftProduct.value.copyWith(variants: updatedVariants);

    variantNameCtrl.clear();
    variantValuesCtrl.clear();
  }

  void removeVariant(String variantId) {
    final updatedVariants = draftProduct.value.variants
        .where((v) => v.id != variantId)
        .toList();
    draftProduct.value = draftProduct.value.copyWith(variants: updatedVariants);
  }

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

      final product = draftProduct.value.copyWith(
        updatedAt: DateTime.now(),
        categoryId: categoryId,
      );

      final result = await addProductUseCase.call(
        AddProductParams(
          product: product,
          openingStock: double.parse(openingStockCtrl.text),
        ),
      );
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          debugPrint(err.message);
        },
        (data) {
          Get.back(result: (product, data.$2));
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

  Future<void> saveDraft() async {
    // if (isSaving.value) return;

    // isSaving.value = true;
    // try {
    //   final draft = draftProduct.value.copyWith(
    //     updatedAt: DateTime.now(),
    //     settings: draftProduct.value.settings.copyWith(isActive: false),
    //   );
    //   await addProductUseCase(draft);
    //   Get.snackbar('Saved', 'Draft saved');
    // } catch (e) {
    //   errorMessage.value = 'Failed to save draft: ${e.toString()}';
    //   Get.snackbar('Error', errorMessage.value!);
    // } finally {
    //   isSaving.value = false;
    // }
  }

  void cancel() => Get.back();

  @override
  void onClose() {
    productNameCtrl.dispose();
    brandCtrl.dispose();
    descriptionCtrl.dispose();
    purchasePriceCtrl.dispose();
    sellingPriceCtrl.dispose();
    mrpCtrl.dispose();
    wholesalePriceCtrl.dispose();
    minSellingPriceCtrl.dispose();
    openingStockCtrl.dispose();
    minStockAlertCtrl.dispose();
    maxStockCtrl.dispose();
    rackLocationCtrl.dispose();
    hsnCodeCtrl.dispose();
    barcodeCtrl.dispose();
    skuCtrl.dispose();
    variantNameCtrl.dispose();
    variantValuesCtrl.dispose();
    internalNotesCtrl.dispose();
    super.onClose();
  }
}
