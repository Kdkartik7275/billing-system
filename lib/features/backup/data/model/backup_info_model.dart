import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'backup_info_model.g.dart';

@HiveType(typeId: HiveTypeIds.backupInfoModel)
class BackupInfoModel {
  @HiveField(0)
  final String filePath;

  @HiveField(1)
  final String appVersion;

  @HiveField(2)
  final int formatVersion;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? shopId;

  @HiveField(5)
  final String? shopName;

  @HiveField(6)
  final int productsCount;

  @HiveField(7)
  final int categoriesCount;

  @HiveField(8)
  final int customersCount;

  @HiveField(9)
  final int suppliersCount;

  @HiveField(10)
  final int billsCount;

  const BackupInfoModel({
    required this.filePath,
    required this.appVersion,
    required this.formatVersion,
    required this.createdAt,
    this.shopId,
    this.shopName,
    required this.productsCount,
    required this.categoriesCount,
    required this.customersCount,
    required this.suppliersCount,
    required this.billsCount,
  });

  factory BackupInfoModel.fromEntity(BackupInfo entity) {
    return BackupInfoModel(
      filePath: entity.filePath,
      appVersion: entity.appVersion,
      formatVersion: entity.formatVersion,
      createdAt: entity.createdAt,
      shopId: entity.shopId,
      shopName: entity.shopName,
      productsCount: entity.productsCount,
      categoriesCount: entity.categoriesCount,
      customersCount: entity.customersCount,
      suppliersCount: entity.suppliersCount,
      billsCount: entity.billsCount,
    );
  }

  BackupInfo toEntity() {
    return BackupInfo(
      filePath: filePath,
      appVersion: appVersion,
      formatVersion: formatVersion,
      createdAt: createdAt,
      shopId: shopId,
      shopName: shopName,
      productsCount: productsCount,
      categoriesCount: categoriesCount,
      customersCount: customersCount,
      suppliersCount: suppliersCount,
      billsCount: billsCount,
    );
  }

  BackupInfoModel copyWith({
    String? filePath,
    String? appVersion,
    int? formatVersion,
    DateTime? createdAt,
    String? shopId,
    String? shopName,
    int? productsCount,
    int? categoriesCount,
    int? customersCount,
    int? suppliersCount,
    int? billsCount,
  }) {
    return BackupInfoModel(
      filePath: filePath ?? this.filePath,
      appVersion: appVersion ?? this.appVersion,
      formatVersion: formatVersion ?? this.formatVersion,
      createdAt: createdAt ?? this.createdAt,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      productsCount: productsCount ?? this.productsCount,
      categoriesCount: categoriesCount ?? this.categoriesCount,
      customersCount: customersCount ?? this.customersCount,
      suppliersCount: suppliersCount ?? this.suppliersCount,
      billsCount: billsCount ?? this.billsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'appVersion': appVersion,
      'formatVersion': formatVersion,
      'createdAt': createdAt.toIso8601String(),
      'shopId': shopId,
      'shopName': shopName,
      'productsCount': productsCount,
      'categoriesCount': categoriesCount,
      'customersCount': customersCount,
      'suppliersCount': suppliersCount,
      'billsCount': billsCount,
    };
  }

  factory BackupInfoModel.fromJson(Map<String, dynamic> json) {
    return BackupInfoModel(
      filePath: json['filePath'] as String,
      appVersion: json['appVersion'] as String,
      formatVersion: json['formatVersion'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      productsCount: json['productsCount'] as int? ?? 0,
      categoriesCount: json['categoriesCount'] as int? ?? 0,
      customersCount: json['customersCount'] as int? ?? 0,
      suppliersCount: json['suppliersCount'] as int? ?? 0,
      billsCount: json['billsCount'] as int? ?? 0,
    );
  }
}