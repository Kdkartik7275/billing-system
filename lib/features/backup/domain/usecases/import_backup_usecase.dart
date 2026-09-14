import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';
import 'package:billing_system/features/backup/domain/repository/backup_repository.dart';

class ImportBackup implements UseCaseWithParams<void, ImportBackupParams> {
  final BackupRepository repository;

  const ImportBackup(this.repository);

  @override
  ResultFuture<void> call(ImportBackupParams params) async {
    return await repository.importBackup(params.filePath, mode: params.mode);
  }
}

class ImportBackupParams {
  final String filePath;
  final BackupImportMode mode;

  const ImportBackupParams({
    required this.filePath,
    this.mode = BackupImportMode.replace,
  });
}
