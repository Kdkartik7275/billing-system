class BackupManifestModel {
  final String format;
  final int version;
  final String appVersion;
  final DateTime createdAt;
  final String? shopId;
  final String? shopName;
  final List<String> boxes;

  const BackupManifestModel({
    required this.format,
    required this.version,
    required this.appVersion,
    required this.createdAt,
    this.shopId,
    this.shopName,
    required this.boxes,
  });

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'version': version,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'shopId': shopId,
      'shopName': shopName,
      'boxes': boxes,
    };
  }

  factory BackupManifestModel.fromJson(Map<String, dynamic> json) {
    return BackupManifestModel(
      format: json['format'] as String,
      version: json['version'] as int,
      appVersion: json['appVersion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      boxes: List<String>.from(json['boxes'] ?? const []),
    );
  }
}
