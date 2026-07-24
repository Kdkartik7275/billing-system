import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class AddProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  final ProductRepository repository;

  const AddProductUseCase(this.repository);

  @override
  Future<ProductEntity> call(ProductEntity params) async {
    final existingByBarcode = await repository.getProductByBarcode(
      params.barcode,
    );
    if (existingByBarcode != null) {
      throw StateError(
        'A product with barcode "${params.barcode}" already exists.',
      );
    }

    final existingBySku = await repository.getProductBySku(params.sku);
    if (existingBySku != null) {
      throw StateError('A product with SKU "${params.sku}" already exists.');
    }

    return repository.addProduct(params);
  }
}
