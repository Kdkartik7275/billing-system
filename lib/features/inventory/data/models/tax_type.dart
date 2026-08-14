import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:hive/hive.dart';

part 'tax_type.g.dart';

@HiveType(typeId: HiveTypeIds.taxTypeModel)
enum TaxTypeModel {
  @HiveField(0)
  exclusive,

  @HiveField(1)
  inclusive,

  @HiveField(2)
  exempt,
}
