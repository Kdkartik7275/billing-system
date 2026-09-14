import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';

abstract interface class BackupRepository {
  ResultFuture<String> exportBackup();

  ResultFuture<BackupInfo> validateBackup(String filePath);

  ResultFuture<void> importBackup(
    String filePath, {
    BackupImportMode mode = BackupImportMode.replace,
  });

  ResultFuture<BackupInfo?> getLastBackup();
}
