import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'held_cart_model.g.dart';

@HiveType(typeId: HiveTypeIds.heldCartModel)
class HeldCartModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? label;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final List<BillItemModel> items;

  HeldCartModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.label,
  });

  HeldCartModel copyWith({
    String? id,
    String? label,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BillItemModel>? items,
  }) {
    return HeldCartModel(
      id: id ?? this.id,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }
}