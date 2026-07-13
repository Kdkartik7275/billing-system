import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';

import 'product_model.dart';

class CartItem {
  final ProductModel product;
  final StockBatch batch;
  int quantity;

  CartItem({required this.product, required this.batch, this.quantity = 1});

  double get total => batch.sellingPrice * quantity;
}
