import 'package:hive_flutter/hive_flutter.dart';

part 'billing.g.dart';

@HiveType(typeId: 20)
enum BillStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  completed,

  @HiveField(2)
  cancelled,

  @HiveField(3)
  refunded,
}

@HiveType(typeId: 21)
enum PaymentMethod {
  @HiveField(0)
  cash,

  @HiveField(1)
  card,

  @HiveField(2)
  upi,

  @HiveField(3)
  wallet,

  @HiveField(4)
  other,
}
