import 'dart:io';

import 'package:billing_system/core/helper/export_products_data.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/usecases/brand/get_brands_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/category/get_categories_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/delete_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/get_products_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_stocks_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/supplier/get_suppliers_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/unit/get_units_usecase.dart';
import 'package:billing_system/features/inventory/presentation/views/product_details/product_detail_page.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/stock_batch_entity.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/entities/warehouse_entity.dart';

enum StockFilter { all, inStock, lowStock, outOfStock }

class InventoryController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetUnitsUsecase getUnitsUsecase;
  final GetStocksUsecase getStocksUsecase;
  final GetBrandsUsecase getBrandsUsecase;
  final GetSuppliersUsecase getSuppliersUsecase;
  final DeleteProductUseCase deleteProductUseCase;

  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxList<BrandEntity> brands = <BrandEntity>[].obs;
  final RxList<UnitEntity> units = <UnitEntity>[].obs;
  final RxList<SupplierEntity> suppliers = <SupplierEntity>[].obs;
  final RxList<WarehouseEntity> warehouses = <WarehouseEntity>[].obs;

  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxList<StockEntity> stockRecords = <StockEntity>[].obs;
  final RxList<StockBatchEntity> stockBatches = <StockBatchEntity>[].obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = 'All'.obs;
  final RxString selectedBrandId = 'All'.obs;
  final RxString selectedSupplierId = 'All'.obs;
  final Rx<StockFilter> selectedStockFilter = StockFilter.all.obs;

  final RxString sortColumn = 'name'.obs;
  final RxBool sortAscending = true.obs;
  final RxBool exporting = false.obs;

  // ── Loading tracking ────────────────────────────────────────

  final RxSet<String> _inFlightLoaders = <String>{}.obs;
  bool get isLoading => _inFlightLoaders.isNotEmpty;

  // ── Error tracking ──────────────────────────────────────────

  final RxMap<String, String> _loadErrors = <String, String>{}.obs;
  Map<String, String> get loadErrors => _loadErrors;
  bool get hasLoadErrors => _loadErrors.isNotEmpty;

  String? get errorMessage =>
      _loadErrors.isEmpty ? null : _loadErrors.values.join('\n');

  final RxBool deleting = false.obs;

  InventoryController({
    required this.getProductsUseCase,
    required this.getCategoriesUsecase,
    required this.getUnitsUsecase,
    required this.getStocksUsecase,
    required this.getBrandsUsecase,
    required this.deleteProductUseCase,
    required this.getSuppliersUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    Future.wait([
      loadProducts(),
      loadCategories(),
      loadStocks(),
      loadBrands(),
      loadUnits(),
      loadSuppliers(),
    ]);
  }

  void _beginLoad(String key) {
    _loadErrors.remove(key); // clear only this loader's previous error
    _inFlightLoaders.add(key);
  }

  void _endLoad(String key) {
    _inFlightLoaders.remove(key);
  }

  void _recordError(String key, String message) {
    _loadErrors[key] = message;
  }

  List<ProductEntity> get lowStockProducts {
    return products
        .where((p) => stockStatusFor(p) == StockStatus.lowStock)
        .toList();
  }

  Future<void> loadProducts() async {
    const key = 'products';
    _beginLoad(key);
    try {
      final result = await getProductsUseCase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (prods) {
          products.assignAll(prods);
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load products: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  Future<void> loadCategories() async {
    const key = 'categories';
    _beginLoad(key);
    try {
      final result = await getCategoriesUsecase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (c) {
          categories.assignAll(c);
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load categories: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  Future<void> loadUnits() async {
    const key = 'units';
    _beginLoad(key);
    try {
      final result = await getUnitsUsecase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (u) {
          units.assignAll(u);
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load units: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  Future<void> loadBrands() async {
    const key = 'brands';
    _beginLoad(key);
    try {
      final result = await getBrandsUsecase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (b) {
          brands.assignAll(b);
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load brands: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  Future<void> loadStocks() async {
    const key = 'stocks';
    _beginLoad(key);
    try {
      final result = await getStocksUsecase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (c) {
          stockRecords.assignAll(c);
          debugPrint(c.length.toString());
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load stocks: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  Future<void> loadSuppliers() async {
    const key = 'suppliers';
    _beginLoad(key);
    try {
      final result = await getSuppliersUsecase.call();
      result.fold(
        (err) {
          AppSnackbar.error(message: err.message);
          _recordError(key, err.message);
        },
        (s) {
          suppliers.assignAll(s);
        },
      );
    } catch (e) {
      _recordError(key, 'Failed to load suppliers: ${e.toString()}');
    } finally {
      _endLoad(key);
    }
  }

  String categoryName(String id) =>
      _firstOrNull(categories, (c) => c.id == id)?.name ?? 'Uncategorized';

  String unitName(String id) =>
      _firstOrNull(units, (c) => c.id == id)?.name ?? 'Uncategorized';

  String? brandName(String? id) {
    if (id == null) return null;
    return _firstOrNull(brands, (b) => b.id == id)?.name;
  }

  String? supplierName(String? id) {
    if (id == null) return null;
    return _firstOrNull(suppliers, (s) => s.id == id)?.name;
  }

  String unitShortCode(String id) =>
      _firstOrNull(units, (u) => u.id == id)?.shortName ?? 'pc';

  static T? _firstOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  double stockQuantityFor(String productId) {
    return stockRecords
        .where((s) => s.productId == productId)
        .fold<double>(0, (sum, s) => sum + s.quantity);
  }

  StockStatus stockStatusFor(ProductEntity product) {
    final qty = stockQuantityFor(product.id);
    if (qty <= 0) return StockStatus.outOfStock;
    if (qty <= product.settings.lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  List<StockBatchEntity> batchesFor(String productId) =>
      stockBatches.where((b) => b.productId == productId).toList();

  int get totalProductsCount => products.length;

  double get totalInventoryValue {
    return products.fold<double>(
      0,
      (sum, p) => sum + (p.price.purchasePrice * stockQuantityFor(p.id)),
    );
  }

  int get lowStockCount =>
      products.where((p) => stockStatusFor(p) == StockStatus.lowStock).length;

  int get outOfStockCount =>
      products.where((p) => stockStatusFor(p) == StockStatus.outOfStock).length;

  int get todaysAddedCount {
    final now = DateTime.now();
    return products
        .where(
          (p) =>
              p.createdAt.year == now.year &&
              p.createdAt.month == now.month &&
              p.createdAt.day == now.day,
        )
        .length;
  }

  List<ProductEntity> get filteredProducts {
    var list = products.where((p) {
      final matchesSearch =
          searchQuery.value.trim().isEmpty ||
          p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.sku.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.barcode.contains(searchQuery.value);

      final matchesCategory =
          selectedCategoryId.value == 'All' ||
          p.categoryId == selectedCategoryId.value;

      final matchesBrand =
          selectedBrandId.value == 'All' || p.brandId == selectedBrandId.value;

      final matchesSupplier =
          selectedSupplierId.value == 'All' ||
          p.primarySupplierId == selectedSupplierId.value;

      final status = stockStatusFor(p);
      final matchesStockFilter = switch (selectedStockFilter.value) {
        StockFilter.all => true,
        StockFilter.inStock => status == StockStatus.inStock,
        StockFilter.lowStock => status == StockStatus.lowStock,
        StockFilter.outOfStock => status == StockStatus.outOfStock,
      };

      return matchesSearch &&
          matchesCategory &&
          matchesBrand &&
          matchesSupplier &&
          matchesStockFilter;
    }).toList();

    list.sort((a, b) {
      int result;
      switch (sortColumn.value) {
        case 'sku':
          result = a.sku.compareTo(b.sku);
          break;
        case 'category':
          result = categoryName(
            a.categoryId,
          ).compareTo(categoryName(b.categoryId));
          break;
        case 'price':
          result = a.price.sellingPrice.compareTo(b.price.sellingPrice);
          break;
        case 'stock':
          result = stockQuantityFor(a.id).compareTo(stockQuantityFor(b.id));
          break;
        case 'supplier':
          result = (supplierName(a.primarySupplierId) ?? '').compareTo(
            supplierName(b.primarySupplierId) ?? '',
          );
          break;
        case 'name':
        default:
          result = a.name.compareTo(b.name);
      }
      return sortAscending.value ? result : -result;
    });

    return list;
  }

  void updateSearch(String value) => searchQuery.value = value;

  void clearSearch() => searchQuery.value = '';

  void selectCategory(String categoryId) =>
      selectedCategoryId.value = categoryId;

  void selectBrand(String brandId) => selectedBrandId.value = brandId;

  void selectSupplier(String supplierId) =>
      selectedSupplierId.value = supplierId;

  void selectStockFilter(StockFilter filter) =>
      selectedStockFilter.value = filter;

  void setSort(String column) {
    if (sortColumn.value == column) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }
  }

  void selectProduct(ProductEntity product) {
    Get.to(
      () => ProductDetailPage(
        product: product,
        stock: stockRecords.firstWhereOrNull((s) => s.productId == product.id),
      ),
    );
  }

  void updateStockQuantityLocally(String productId, double newQuantity) {
    final index = stockRecords.indexWhere((s) => s.productId == productId);

    if (index == -1) {
      return;
    }

    stockRecords[index] = stockRecords[index].copyWith(
      quantity: newQuantity,
      lastUpdated: DateTime.now(),
    );

    stockRecords.refresh();
  }

  Future<void> refreshProducts() async {
    debugPrint('Refreshing products...');
    await loadProducts();
  }

  void deleteProduct(String productId) async {
    deleting.value = true;
    final result = await deleteProductUseCase.call(productId);

    result.fold((err) => AppSnackbar.error(message: err.message), (r) {
      products.removeWhere((p) => p.id == productId);
      stockRecords.removeWhere((s) => s.productId == productId);
      stockBatches.removeWhere((b) => b.productId == productId);
    });
    deleting.value = false;
  }

  void updateProduct(ProductEntity updatedProduct) {
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
    }
  }

  Future<void> exportProducts() async {
    if (exporting.value) return;

    exporting.value = true;
    try {
      final rowsToExport = filteredProducts;

      if (rowsToExport.isEmpty) {
        AppSnackbar.info(message: 'No products to export.');
        return;
      }

      AppSnackbar.info(
        message: 'Preparing ${rowsToExport.length} products for export…',
      );

      final exportRows = rowsToExport
          .map(
            (p) => ProductExportRow(
              name: p.name,
              sku: p.sku,
              barcode: p.barcode,
              category: categoryName(p.categoryId),
              brand: brandName(p.brandId),
              unit: unitName(p.unitId),
              purchasePrice: p.price.purchasePrice,
              sellingPrice: p.price.sellingPrice,
              stockQuantity: stockQuantityFor(p.id),
              stockStatus: stockStatusFor(p),
              isActive: p.settings.isActive,
            ),
          )
          .toList();

      final result = await const ProductPdfExporter().export(
        rows: exportRows,
        title: 'Product Inventory Report',
      );

      await _shareOrOpen(result);
    } catch (e) {
      AppSnackbar.error(message: 'Export failed: ${e.toString()}');
      debugPrint('Export failed: ${e.toString()}');
    } finally {
      exporting.value = false;
    }
  }

  Future<void> _shareOrOpen(ProductExportResult result) async {
    try {
      await Printing.sharePdf(bytes: result.bytes, filename: result.fileName);
    } catch (e) {
      AppSnackbar.error(message: 'Could not open share sheet: ${e.toString()}');
    }
  }
}
