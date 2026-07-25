import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late MockInventoryRepository repository;
  late GetProductsUsecase usecase;

  setUp(() {
    repository = MockInventoryRepository();
    usecase = GetProductsUsecase(repository);
  });

  test('should return product list from repository', () async {
    final products = <InventoryProduct>[];

    when(
      () => repository.getProducts(),
    ).thenAnswer((_) async => Right(products));

    final result = await usecase.call();

    expect(result, Right(products));

    verify(() => repository.getProducts()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
