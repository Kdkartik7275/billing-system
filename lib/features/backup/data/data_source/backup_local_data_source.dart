import 'package:billing_system/features/backup/data/model/backup_info_model.dart';
import 'package:billing_system/features/backup/data/model/backup_record_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class BackupLocalDataSource {
  // ============================
  // BACKUP METADATA
  // ============================

  Future<void> saveLastBackupInfo(BackupInfoModel backupInfo);

  Future<BackupInfoModel?> getLastBackupInfo();

  Future<void> deleteLastBackupInfo();

  Future<void> clearBackupMetadata();

  // ============================
  // HIVE DATA EXPORT
  // ============================

  Future<List<BackupRecordModel>> exportBox<T>({
    required Box<T> box,
    required Map<String, dynamic> Function(T value) toJson,
  });

  // ============================
  // HIVE DATA IMPORT
  // ============================

  Future<void> importBox<T>({
    required Box<T> box,
    required List<BackupRecordModel> records,
    required T Function(Map<String, dynamic> json) fromJson,
    bool clearBeforeImport = true,
  });

  // ============================
  // CLEAR HIVE BOX
  // ============================

  Future<void> clearBox<T>(Box<T> box);
}

class BackupLocalDataSourceImpl implements BackupLocalDataSource {
  final Box<BackupInfoModel> backupBox;

  BackupLocalDataSourceImpl({required this.backupBox});

  static const String _lastBackupKey = 'last_backup';

  // ============================
  // METADATA
  // ============================

  @override
  Future<void> saveLastBackupInfo(BackupInfoModel backupInfo) async {
    try {
      await backupBox.put(_lastBackupKey, backupInfo);
    } catch (e) {
      throw Exception('Failed to save backup information: $e');
    }
  }

  @override
  Future<BackupInfoModel?> getLastBackupInfo() async {
    try {
      return backupBox.get(_lastBackupKey);
    } catch (e) {
      throw Exception('Failed to fetch backup information: $e');
    }
  }

  @override
  Future<void> deleteLastBackupInfo() async {
    try {
      await backupBox.delete(_lastBackupKey);
    } catch (e) {
      throw Exception('Failed to delete backup information: $e');
    }
  }

  @override
  Future<void> clearBackupMetadata() async {
    try {
      await backupBox.clear();
    } catch (e) {
      throw Exception('Failed to clear backup metadata: $e');
    }
  }

  // ============================
  // EXPORT BOX
  // ============================

  @override
  Future<List<BackupRecordModel>> exportBox<T>({
    required Box<T> box,
    required Map<String, dynamic> Function(T value) toJson,
  }) async {
    try {
      final records = <BackupRecordModel>[];

      for (final key in box.keys) {
        final value = box.get(key);

        if (value == null) {
          continue;
        }

        records.add(BackupRecordModel(key: key, data: toJson(value)));
      }

      return records;
    } catch (e) {
      throw Exception('Failed to export box "${box.name}": $e');
    }
  }

  // ============================
  // IMPORT BOX
  // ============================

  @override
  Future<void> importBox<T>({
    required Box<T> box,
    required List<BackupRecordModel> records,
    required T Function(Map<String, dynamic> json) fromJson,
    bool clearBeforeImport = true,
  }) async {
    try {
      if (clearBeforeImport) {
        await box.clear();
      }

      for (final record in records) {
        final model = fromJson(record.data);

        await box.put(record.key, model);
      }
    } catch (e) {
      throw Exception('Failed to import box "${box.name}": $e');
    }
  }

  // ============================
  // CLEAR BOX
  // ============================

  @override
  Future<void> clearBox<T>(Box<T> box) async {
    try {
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear box "${box.name}": $e');
    }
  }
}
