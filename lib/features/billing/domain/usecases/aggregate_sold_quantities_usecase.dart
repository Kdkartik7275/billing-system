import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/entities/product_sales_aggregate.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class AggregateSoldQuantitiesUsecase
    implements
        UseCaseWithParams<List<ProductSalesAggregate>, List<BillEntity>> {
  final ProductRepository productRepository;

  AggregateSoldQuantitiesUsecase({required this.productRepository});

  @override
  ResultFuture<List<ProductSalesAggregate>> call(List<BillEntity> bills) async {
    // ---------------- SUM QUANTITY PER PRODUCT ID ----------------
    final Map<String, double> quantityByProductId = {};

    for (final bill in bills) {
      for (final item in bill.items) {
        quantityByProductId.update(
          item.productId,
          (existing) => existing + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }
    }

    if (quantityByProductId.isEmpty) {
      return const Right([]);
    }

    // ---------------- ATTACH FULL PRODUCT DETAILS ----------------
    final aggregates = <ProductSalesAggregate>[];

    for (final entry in quantityByProductId.entries) {
      final productResult = await productRepository.getProductById(entry.key);

      productResult.fold(
        (_) {
          // Product lookup failed — skip, don't fail the whole batch.
        },
        (product) {
          if (product != null) {
            aggregates.add(
              ProductSalesAggregate(
                product: product,
                quantitySold: entry.value,
              ),
            );
          }
        },
      );
    }

    return Right(aggregates);
  }
}
