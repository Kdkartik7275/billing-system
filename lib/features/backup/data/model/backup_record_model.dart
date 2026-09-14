class BackupRecordModel {
  final dynamic key;
  final Map<String, dynamic> data;

  const BackupRecordModel({required this.key, required this.data});

  Map<String, dynamic> toJson() {
    return {'key': key, 'data': data};
  }

  factory BackupRecordModel.fromJson(Map<String, dynamic> json) {
    return BackupRecordModel(
      key: json['key'],
      data: Map<String, dynamic>.from(json['data'] as Map),
    );
  }
}
