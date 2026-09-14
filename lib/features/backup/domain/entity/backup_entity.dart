class BackupInfo {
  final String filePath;
  final String appVersion;
  final int formatVersion;
  final DateTime createdAt;
  final String? shopId;
  final String? shopName;
  final int productsCount;
  final int categoriesCount;
  final int customersCount;
  final int suppliersCount;
  final int billsCount;

  const BackupInfo({
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
}


enum BackupImportMode {
  replace,
  merge,
}