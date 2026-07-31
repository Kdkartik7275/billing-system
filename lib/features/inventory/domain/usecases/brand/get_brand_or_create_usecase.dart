import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/brand_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/brand_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class GetOrCreateBrandUseCase
    implements UseCaseWithParams<BrandEntity, String> {
  final BrandRepository repository;

  const GetOrCreateBrandUseCase(this.repository);

  @override
  ResultFuture<BrandEntity> call(String brandName) async {
    final normalized = brandName.trim().toLowerCase();

    final existing = await repository.getBrandByName(normalized);

    return existing.fold((failure) async => left(failure), (brand) async {
      if (brand != null) {
        return right(brand);
      }

      final newBrand = BrandEntity(
        id: const Uuid().v4(),
        name: _formatBrandName(brandName),
        searchName: normalized,
        createdAt: DateTime.now(),
      );

      return repository.addBrand(newBrand);
    });
  }

  String _formatBrandName(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
