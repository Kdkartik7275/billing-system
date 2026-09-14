import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';
import 'package:billing_system/features/backup/domain/repository/backup_repository.dart';

class GetLastBackup implements UseCaseWithoutParams<BackupInfo?> {
  final BackupRepository repository;

  const GetLastBackup(this.repository);

  @override
  ResultFuture<BackupInfo?> call() async {
    return await repository.getLastBackup();
  }
}
