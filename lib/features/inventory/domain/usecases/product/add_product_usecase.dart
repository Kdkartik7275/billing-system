import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/brand/get_brand_or_create_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class AddProductParams {
  final ProductEntity product;
  final double openingStock;

  const AddProductParams({required this.product, required this.openingStock});
}

class AddProductUseCase
    implements
        UseCaseWithParams<(ProductEntity, StockEntity), AddProductParams> {
  final ProductRepository productRepository;
  final StockRepository stockRepository;
  final GetOrCreateBrandUseCase getOrCreateBrandUseCase;

  const AddProductUseCase({
    required this.productRepository,
    required this.stockRepository,
    required this.getOrCreateBrandUseCase,
  });

  @override
  ResultFuture<(ProductEntity, StockEntity)> call(
    AddProductParams params,
  ) async {
    // ---------------- Barcode Validation ----------------

    final barcodeResult = await productRepository.getProductByBarcode(
      params.product.barcode,
    );

    final barcodeFailure = barcodeResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (barcodeFailure != null) {
      return left(barcodeFailure);
    }

    if (barcodeResult.getRight().toNullable() != null) {
      return left(
        FirebaseFailure(
          message:
              'A product with barcode "${params.product.barcode}" already exists.',
        ),
      );
    }

    // ---------------- SKU Validation ----------------

    final skuResult = await productRepository.getProductBySku(
      params.product.sku,
    );

    final skuFailure = skuResult.fold((failure) => failure, (_) => null);

    if (skuFailure != null) {
      return left(skuFailure);
    }

    if (skuResult.getRight().toNullable() != null) {
      return left(
        FirebaseFailure(
          message: 'A product with SKU "${params.product.sku}" already exists.',
        ),
      );
    }

    // ---------------- Get or Create Brand ----------------

    final brandResult = await getOrCreateBrandUseCase.call(
      params.product.brandId ?? '',
    );

    final brandFailure = brandResult.fold((failure) => failure, (_) => null);

    if (brandFailure != null) {
      return left(brandFailure);
    }

    final brand = brandResult.getRight().toNullable()!;

    // ---------------- Update Product ----------------

    final productToCreate = params.product.copyWith(brandId: brand.id);

    // ---------------- Create Product ----------------

    final productResult = await productRepository.addProduct(productToCreate);

    final productFailure = productResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (productFailure != null) {
      return left(productFailure);
    }

    final createdProduct = productResult.getRight().toNullable()!;

    // ---------------- Create Initial Stock ----------------

    final stock = StockEntity(
      id: const Uuid().v4(),
      productId: createdProduct.id,
      warehouseId: 'default',
      quantity: params.openingStock,
      reservedQuantity: 0,
      lastUpdated: DateTime.now(),
    );

    final stockResult = await stockRepository.createInitialStock(stock);

    final stockFailure = stockResult.fold((failure) => failure, (_) => null);

    if (stockFailure != null) {
      return left(stockFailure);
    }

    final createdStock = stockResult.getRight().toNullable()!;

    return right((createdProduct, createdStock));
  }
}
