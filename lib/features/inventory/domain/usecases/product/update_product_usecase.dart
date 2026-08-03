import 'dart:io';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/brand/get_brand_or_create_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/upload_product_images.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_image.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProductUseCase
    implements UseCaseWithParams<ProductEntity, ProductEntity> {
  final ProductRepository productRepository;
  final GetOrCreateBrandUseCase getOrCreateBrandUseCase;
  final UploadProductImages uploadProductImages;

  const UpdateProductUseCase({
    required this.productRepository,
    required this.getOrCreateBrandUseCase,
    required this.uploadProductImages,
  });

  @override
  ResultFuture<ProductEntity> call(ProductEntity params) async {
    // ---------------- Get/Create Brand ----------------

    final brandResult = await getOrCreateBrandUseCase(params.brandId ?? '');

    final brandFailure = brandResult.fold((failure) => failure, (_) => null);

    if (brandFailure != null) {
      return left(brandFailure);
    }

    final brand = brandResult.getRight().toNullable()!;

    // ---------------- Split Images ----------------

    final existingImages = params.images
        .where((e) => e.url.startsWith('https'))
        .toList();

    final newImages = params.images
        .where((e) => !e.url.startsWith('https'))
        .toList();

    List<String> uploadedUrls = [];

    if (newImages.isNotEmpty) {
      final uploadResult = await uploadProductImages(
        newImages.map((e) => File(e.url)).toList(),
      );

      final uploadFailure = uploadResult.fold(
        (failure) => failure,
        (_) => null,
      );

      if (uploadFailure != null) {
        return left(uploadFailure);
      }

      uploadedUrls = uploadResult.getRight().toNullable()!;
    }

    // ---------------- Merge Images ----------------

    final allImages = <ProductImage>[
      ...existingImages,
      ...uploadedUrls.map((url) => ProductImage(url: url)),
    ];

    final finalImages = List.generate(
      allImages.length,
      (index) => allImages[index].copyWith(isPrimary: index == 0),
    );

    // ---------------- Update Product ----------------

    final productToUpdate = params.copyWith(
      brandId: brand.id,
      images: finalImages,
      updatedAt: DateTime.now(),
    );

    return await productRepository.updateProduct(productToUpdate);
  }
}
