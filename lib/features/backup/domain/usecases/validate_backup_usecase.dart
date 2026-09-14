import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';
import 'package:billing_system/features/backup/domain/repository/backup_repository.dart';

class ValidateBackup implements UseCaseWithParams<BackupInfo, String> {
  final BackupRepository repository;

  const ValidateBackup(this.repository);

  @override
  ResultFuture<BackupInfo> call(String filePath) async {
    return await repository.validateBackup(filePath);
  }
}
