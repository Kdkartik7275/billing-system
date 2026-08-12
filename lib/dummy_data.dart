import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/unit/add_unit_usecase.dart';
import 'package:flutter/foundation.dart';

final List<UnitEntity> dummyUnits = [
  UnitEntity(
    id: 'unit_pcs',
    name: 'Pieces',
    shortName: 'pcs',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_kg',
    name: 'Kilogram',
    shortName: 'kg',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_g',
    name: 'Gram',
    shortName: 'g',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_l',
    name: 'Litre',
    shortName: 'L',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_ml',
    name: 'Millilitre',
    shortName: 'ml',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_m',
    name: 'Meter',
    shortName: 'm',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_cm',
    name: 'Centimeter',
    shortName: 'cm',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_box',
    name: 'Box',
    shortName: 'box',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_pack',
    name: 'Pack',
    shortName: 'pack',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_dozen',
    name: 'Dozen',
    shortName: 'doz',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_pair',
    name: 'Pair',
    shortName: 'pair',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_bottle',
    name: 'Bottle',
    shortName: 'btl',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_can',
    name: 'Can',
    shortName: 'can',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_bag',
    name: 'Bag',
    shortName: 'bag',
    createdAt: DateTime.now(),
  ),
  UnitEntity(
    id: 'unit_bundle',
    name: 'Bundle',
    shortName: 'bundle',
    createdAt: DateTime.now(),
  ),
];

Future<void> uploadDummyUnits() async {
  for (final unit in dummyUnits) {
    final result = await sl<AddUnitUsecase>().call(unit);

    result.fold(
      (failure) => debugPrint('Failed: ${failure.message}'),
      (uploadedUnit) => debugPrint('Uploaded: ${uploadedUnit.name}'),
    );
  }
}
