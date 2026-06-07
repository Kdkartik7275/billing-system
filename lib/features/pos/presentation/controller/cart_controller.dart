import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  final RxBool isScannerOpen = false.obs;
  final RxString lastScannedBarcode = ''.obs;
  final RxString scanFeedbackMessage = ''.obs;
  final RxBool scanSuccess = false.obs;

  bool _scanDebouncing = false;
  List<InventoryProduct> get inventoryProducts =>
      Get.find<InventoryController>().products;

  List<ProductModel> get filteredProducts {
    var list = inventoryProducts;

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
                p.barcode.contains(q),
          )
          .toList();
    }

    return list
        .map(
          (p) => ProductModel(
            id: p.id,
            name: p.name,
            category: p.category,
            price: p.price,
            stock: p.stock,
            imageUrl: p.imageUrl,
            barcode: p.barcode,
            sku: p.sku,
          ),
        )
        .toList();
  }

  double get subtotal => cartItems.fold(0, (sum, i) => sum + i.total);
  double get tax => subtotal * 0.05;
  double get grandTotal => subtotal + tax;
  int get totalItemCount => cartItems.fold(0, (sum, i) => sum + i.quantity);

  void addToCart(ProductModel product) {
    final idx = cartItems.indexWhere((i) => i.product.id == product.id);
    if (idx != -1) {
      cartItems[idx].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  void removeFromCart(String productId) {
    final idx = cartItems.indexWhere((i) => i.product.id == productId);
    if (idx != -1) {
      if (cartItems[idx].quantity > 1) {
        cartItems[idx].quantity--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(idx);
      }
    }
  }

  void deleteCartItem(String productId) =>
      cartItems.removeWhere((i) => i.product.id == productId);

  void clearCart() => cartItems.clear();

  int cartQty(String productId) {
    final match = cartItems.where((i) => i.product.id == productId);
    return match.isEmpty ? 0 : match.first.quantity;
  }

  void openScanner() => isScannerOpen.value = true;

  void closeScanner() {
    isScannerOpen.value = false;
    scanFeedbackMessage.value = '';
    lastScannedBarcode.value = '';
    _scanDebouncing = false;
  }

  void onBarcodeScanned(String barcode) {
    if (barcode.trim().isEmpty) return;
    if (_scanDebouncing) return;

    _scanDebouncing = true;
    lastScannedBarcode.value = barcode;

    final inventoryProduct = inventoryProducts.firstWhereOrNull(
      (p) => p.barcode == barcode || p.id == barcode,
    );

    if (inventoryProduct != null) {
      final product = ProductModel(
        id: inventoryProduct.id,
        name: inventoryProduct.name,
        category: inventoryProduct.category,
        price: inventoryProduct.price,
        stock: inventoryProduct.stock,
        imageUrl: inventoryProduct.imageUrl,
        barcode: inventoryProduct.barcode,
        sku: inventoryProduct.sku,
      );

      addToCart(product);

      scanSuccess.value = true;
      scanFeedbackMessage.value = '${inventoryProduct.name} added to cart';
    } else {
      scanSuccess.value = false;
      scanFeedbackMessage.value = 'Product not found: $barcode';
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      _scanDebouncing = false;
      scanFeedbackMessage.value = '';
      lastScannedBarcode.value = '';
    });
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void updateSearch(String query) => searchQuery.value = query;
  void clearSearch() => searchQuery.value = '';
}
