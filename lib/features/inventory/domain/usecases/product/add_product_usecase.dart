import 'dart:io';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/brand/get_brand_or_create_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/upload_product_images.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/create_stock_batch_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/create_stock_movement_usecase.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_image.dart';
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
  final UploadProductImages uploadProductImages;
  final CreateStockBatchUsecase createStockBatchUseCase;
  final CreateStockMovementUsecase createStockMovementUseCase;

  const AddProductUseCase({
    required this.productRepository,
    required this.stockRepository,
    required this.getOrCreateBrandUseCase,
    required this.uploadProductImages,
    required this.createStockBatchUseCase,
    required this.createStockMovementUseCase,
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

    // ---------------- Upload Product Images ----------------

    List<String> imageUrls = [];

    if (params.product.images.isNotEmpty) {
      final files = params.product.images
          .map((image) => File(image.url))
          .toList();

      final uploadResult = await uploadProductImages.call(files);

      final uploadFailure = uploadResult.fold(
        (failure) => failure,
        (_) => null,
      );

      if (uploadFailure != null) {
        return left(uploadFailure);
      }

      imageUrls = uploadResult.getRight().toNullable()!;
    }

    // ---------------- Update Product ----------------

    final productToCreate = params.product.copyWith(
      brandId: brand.id,
      images: List.generate(
        imageUrls.length,
        (index) => ProductImage(url: imageUrls[index], isPrimary: index == 0),
      ),
    );

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

    // ---------------- Create Opening Batch & Movement ----------------

    if (params.openingStock > 0) {
      final batchResult = await createStockBatchUseCase.call(
        StockBatchEntity(
          productId: createdProduct.id,
          warehouseId: createdStock.warehouseId,
          quantity: params.openingStock,
          purchasePrice: createdProduct.price.purchasePrice,
          manufactureDate: null,
          expiryDate: null,
          id: Uuid().v4(),
          batchNumber: 'OPEN-${createdProduct.sku}',
          receivedAt: DateTime.now(),
        ),
      );

      final batchFailure = batchResult.fold((l) => l, (_) => null);

      if (batchFailure != null) {
        return left(batchFailure);
      }

      final batch = batchResult.getRight().toNullable()!;

      final movementResult = await createStockMovementUseCase.call(
        StockMovementEntity(
          productId: createdProduct.id,
          warehouseId: createdStock.warehouseId,
          batchId: batch.id,
          variantId: null,
          type: StockMovementType.purchaseIn,
          quantityChange: params.openingStock,
          resultingQuantity: params.openingStock,
          referenceId: createdProduct.id,
          reason: 'Opening Stock',
          id: Uuid().v4(),
          createdAt: DateTime.now(),
        ),
      );

      final movementFailure = movementResult.fold((l) => l, (_) => null);

      if (movementFailure != null) {
        return left(movementFailure);
      }
    }
    return right((createdProduct, createdStock));
  }
}
