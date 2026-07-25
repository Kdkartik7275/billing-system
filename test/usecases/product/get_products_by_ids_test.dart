import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/repository/inventory_repository.dart';
import 'package:billing_system/features/inventory/domain/usecases/get_products_byids.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late MockInventoryRepository repository;
  late GetProductsByids usecase;

  setUp(() {
    repository = MockInventoryRepository();
    usecase = GetProductsByids(repository: repository);
  });

  test('should call repository.getProductsByIds() with correct ids', () async {
    final ids = ['1', '2', '3'];
    final products = <InventoryProduct>[];

    when(
      () => repository.getProductsByIds(any()),
    ).thenAnswer((_) async => Right(products));

    final result = await usecase(ids);

    expect(result, Right(products));

    verify(() => repository.getProductsByIds(ids)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
