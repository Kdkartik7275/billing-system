import 'dart:io';

import 'package:billing_system/core/services/storage/storage_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/add_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/refresh_products_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/update_product_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final AddProductUsecase addProductUseCase;
  final GetProductsUsecase getProductsUseCase;
  final RefreshProductsUsecase refreshProductsUseCase;
  final UpdateProductUsecase updateProductUseCase;
  final RxList<InventoryProduct> products = <InventoryProduct>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString sortColumn = 'name'.obs;
  final RxBool sortAscending = true.obs;
  final RxBool addingNewProduct = false.obs;
  final RxBool loading = false.obs;

  InventoryController({
    required this.addProductUseCase,
    required this.getProductsUseCase,
    required this.refreshProductsUseCase,
    required this.updateProductUseCase,
  });

  List<InventoryProduct> get filteredProducts {
    var list = products.toList();

    if (selectedCategory.value != 'All') {
      list = list.where((p) => p.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.sku.toLowerCase().contains(q) ||
                p.barcode.contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }

    // Sort
    list.sort((a, b) {
      int cmp;
      switch (sortColumn.value) {
        case 'sku':
          cmp = a.sku.compareTo(b.sku);
        case 'category':
          cmp = a.category.compareTo(b.category);
        case 'price':
          cmp = a.price.compareTo(b.price);
        case 'stock':
          cmp = a.stock.compareTo(b.stock);
        case 'supplier':
          cmp = a.supplier.compareTo(b.supplier);
        default:
          cmp = a.name.compareTo(b.name);
      }
      return sortAscending.value ? cmp : -cmp;
    });

    return list;
  }

  // ── Stats ─────────────────────────────────────────────────────────
  int get totalProducts => products.length;
  double get totalValue => products.fold(0, (sum, p) => sum + p.totalValue);
  int get lowStockCount =>
      products.where((p) => p.status == StockStatus.lowStock).length;

  List<InventoryProduct> get lowStocks =>
      products.where((p) => p.status == StockStatus.lowStock || p.status == StockStatus.outOfStock).toList();
  int get outOfStockCount =>
      products.where((p) => p.status == StockStatus.outOfStock).length;
  int get categoryCount => products.map((p) => p.category).toSet().length;

  // ── Operations ────────────────────────────────────────────────────
  void updateSearch(String q) => searchQuery.value = q;
  void clearSearch() => searchQuery.value = '';
  void selectCategory(String cat) => selectedCategory.value = cat;

  void setSort(String column) {
    if (sortColumn.value == column) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }
  }

  Future<void> getProducts() async {
    loading.value = true;
    try {
      final result = await getProductsUseCase.call();
      result.fold((failure) => AppSnackbar.error(message: failure.message), (
        productsList,
      ) {
        debugPrint('Products fetched: ${productsList.length}');
        products.value = productsList;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      AppSnackbar.error(message: 'Failed to get products');
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    loading.value = true;
    try {
      final result = await refreshProductsUseCase.call();
      result.fold((failure) => AppSnackbar.error(message: failure.message), (
        productsList,
      ) {
        debugPrint('Products fetched: ${productsList.length}');
        products.value = productsList;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      AppSnackbar.error(message: 'Failed to get products');
    } finally {
      loading.value = false;
    }
  }

  Future<void> addProduct(InventoryProduct product, {File? imageFile}) async {
    addingNewProduct.value = true;
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }
      final newProduct = product.copywith(imageUrl: imageUrl);
      final result = await addProductUseCase.call(newProduct);
      result.fold((failure) => AppSnackbar.error(message: failure.message), (
        success,
      ) {
        products.add(newProduct);
        AppSnackbar.success(message: 'Product added successfully');
      });
    } catch (e) {
      debugPrint('Error adding product: $e');
      AppSnackbar.error(message: 'Failed to add product');
    } finally {
      addingNewProduct.value = false;
    }
  }

  Future<String?> uploadImage(File filePath) async {
    final storageService = StorageService();
    return await storageService.uploadFileData(filePath);
  }

  void deleteProduct(String id) => products.removeWhere((p) => p.id == id);

  Future<void> updateProduct(InventoryProduct updated) async {
    final idx = products.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      products[idx] = updated;
      await updateProductUseCase.call(updated);
    }
  }
}
