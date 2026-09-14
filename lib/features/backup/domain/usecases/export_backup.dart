import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/backup/domain/repository/backup_repository.dart';

class ExportBackup implements UseCaseWithoutParams<String> {
  final BackupRepository repository;

  const ExportBackup(this.repository);

  @override
  ResultFuture<String> call() async {
    return await repository.exportBackup();
  }
}
