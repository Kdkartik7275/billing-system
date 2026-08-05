import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:get/get.dart';

class CartItem {
  final ProductEntity product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartController extends GetxController {
  final RxMap<String, CartItem> cartItems = <String, CartItem>{}.obs;

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

  double get totalAmount {
    return cartItems.values.fold(
      0.0,
      (sum, item) => sum + (item.product.finalSellingPrice * item.quantity),
    );
  }

  // ---------------- CART ACTIONS ----------------

  void addToCart(ProductEntity product) {
    final existing = cartItems[product.id];
    if (existing != null) {
      existing.quantity++;
    } else {
      cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    cartItems.refresh();
  }

  void incrementQuantity(String productId) {
    final item = cartItems[productId];
    if (item == null) return;
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

  void removeFromCart(String productId) {
    cartItems.remove(productId);
  }

  void clearCart() {
    cartItems.clear();
  }
}
