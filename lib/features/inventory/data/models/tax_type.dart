import 'package:hive/hive.dart';

part 'tax_type.g.dart';

@HiveType(typeId: 11)
enum TaxTypeModel {
  @HiveField(0)
  exclusive,

  @HiveField(1)
  inclusive,

  @HiveField(2)
  exempt,
}
