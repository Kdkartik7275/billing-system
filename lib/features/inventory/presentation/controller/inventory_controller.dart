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

  final RxBool isLoading = false.obs;
  final RxBool deleting = false.obs;
  final RxnString errorMessage = RxnString();

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

  List<ProductEntity> get lowStockProducts {
    return products
        .where((p) => stockStatusFor(p) == StockStatus.lowStock)
        .toList();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getProductsUseCase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (prods) {
        products.assignAll(prods);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getCategoriesUsecase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (c) {
        categories.assignAll(c);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUnits() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getUnitsUsecase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (u) {
        units.assignAll(u);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load units: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBrands() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getBrandsUsecase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (b) {
        brands.assignAll(b);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStocks() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getStocksUsecase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (c) {
        stockRecords.assignAll(c);
        debugPrint(c.length.toString());
      });
    } catch (e) {
      errorMessage.value = 'Failed to load stocks: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSuppliers() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await getSuppliersUsecase.call();
      result.fold((err) => AppSnackbar.error(message: err.message), (s) {
        suppliers.assignAll(s);
      });
    } catch (e) {
      errorMessage.value = 'Failed to load units: ${e.toString()}';
    } finally {
      isLoading.value = false;
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

  void exportProducts() {
    Get.snackbar(
      'Export started',
      'Preparing ${filteredProducts.length} products for export…',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
