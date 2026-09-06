import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:get/get.dart';

class CartItem {
  final ProductEntity product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartController extends GetxController {
  final RxMap<String, CartItem> cartItems = <String, CartItem>{}.obs;

  final RxnString selectedProductId = RxnString();

  List<CartItem> get _orderedItems => cartItems.values.toList();

  final int Function(String productId) getAvailableStock;

  CartController({required this.getAvailableStock});

  // ---------------- QUANTITY GETTERS ----------------

  int quantityFor(String productId) {
    return cartItems[productId]?.quantity ?? 0;
  }

  int get totalItems {
    return cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  // ---------------- PRICE / TAX GETTERS ----------------

  double get subtotal {
    return cartItems.values.fold(
      0.0,
      (sum, item) => sum + (item.product.price.sellingPrice * item.quantity),
    );
  }

  double get totalTax {
    return cartItems.values.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.product.tax.taxAmountFor(item.product.price.sellingPrice) *
              item.quantity),
    );
  }

  double get totalAmount => subtotal + totalTax;

  // ---------------- CART ACTIONS (STOCK-AWARE INTERNALLY) ----------------

  void addToCart(ProductEntity product) {
    final availableStock = getAvailableStock(product.id);

    if (availableStock <= 0) {
      AppSnackbar.error(message: '${product.name} is out of stock');
      return;
    }

    final existing = cartItems[product.id];

    if (existing != null) {
      if (existing.quantity >= availableStock) {
        AppSnackbar.error(
          message: 'Only $availableStock in stock for ${product.name}',
        );
        return;
      }
      existing.quantity++;
    } else {
      cartItems[product.id] = CartItem(product: product, quantity: 1);
    }

    cartItems.refresh();
  }

  void incrementQuantity(String productId) {
    final item = cartItems[productId];
    if (item == null) return;

    final availableStock = getAvailableStock(productId);

    if (item.quantity >= availableStock) {
      AppSnackbar.error(
        message: 'Only $availableStock in stock for ${item.product.name}',
      );
      return;
    }

    item.quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(String productId) {
    final item = cartItems[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      cartItems.remove(productId);
    } else {
      item.quantity--;
      cartItems.refresh();
    }
  }

  void setQuantity(String productId, int quantity) {
    if (quantity < 0) return;

    final availableStock = getAvailableStock(productId);

    if (quantity == 0) {
      cartItems.remove(productId);
      return;
    }

    final existing = cartItems[productId];

    if (existing == null) {
      AppSnackbar.error(message: 'Item is not in the cart.');
      return;
    }

    if (quantity > availableStock) {
      AppSnackbar.error(
        message: 'Only $availableStock in stock for ${existing.product.name}',
      );
      existing.quantity = availableStock;
      cartItems.refresh();
      return;
    }

    existing.quantity = quantity;
    cartItems.refresh();
  }

  void selectNext() {
    final items = _orderedItems;
    if (items.isEmpty) return;
    final currentIndex = items.indexWhere(
      (i) => i.product.id == selectedProductId.value,
    );
    final nextIndex = currentIndex == -1
        ? 0
        : (currentIndex + 1).clamp(0, items.length - 1);
    selectedProductId.value = items[nextIndex].product.id;
  }

  void selectPrevious() {
    final items = _orderedItems;
    if (items.isEmpty) return;
    final currentIndex = items.indexWhere(
      (i) => i.product.id == selectedProductId.value,
    );
    final prevIndex = currentIndex <= 0 ? 0 : currentIndex - 1;
    selectedProductId.value = items[prevIndex].product.id;
  }

  void incrementSelected() {
    final id = selectedProductId.value;
    if (id != null) incrementQuantity(id);
  }

  void decrementSelected() {
    final id = selectedProductId.value;
    if (id != null) decrementQuantity(id);
  }

  void removeSelected() {
    final id = selectedProductId.value;
    if (id == null) return;
    removeFromCart(id);
    selectedProductId.value = null;
  }

  Map<String, int> exportQuantities() {
    return {
      for (final item in cartItems.values) item.product.id: item.quantity,
    };
  }

  void loadFromQuantities(
    Map<String, int> quantities,
    List<ProductEntity> availableProducts,
  ) {
    cartItems.clear();
    for (final entry in quantities.entries) {
      final product = availableProducts.firstWhereOrNull(
        (p) => p.id == entry.key,
      );
      if (product == null) continue;
      cartItems[entry.key] = CartItem(product: product, quantity: entry.value);
    }
    cartItems.refresh();
  }

  void removeFromCart(String productId) {
    cartItems.remove(productId);
  }

  void clearCart() {
    cartItems.clear();
  }
}
