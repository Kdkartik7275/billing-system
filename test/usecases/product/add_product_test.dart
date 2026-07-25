import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/add_product_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class FakeInventoryProduct extends Fake implements InventoryProduct {}

void main() {
  late MockInventoryRepository repository;
  late AddProductUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeInventoryProduct());
  });

  setUp(() {
    repository = MockInventoryRepository();
    usecase = AddProductUsecase(repository);
  });

  test(
    'should call repository.addProduct() with the correct product',
    () async {
      final product = FakeInventoryProduct();

      when(
        () => repository.addProduct(product),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(product);

      expect(result, const Right(null));

      verify(() => repository.addProduct(product)).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
