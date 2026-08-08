import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';

class ProductSalesAggregate {
  final ProductEntity product;
  final double quantitySold;

  const ProductSalesAggregate({
    required this.product,
    required this.quantitySold,
  });
}
