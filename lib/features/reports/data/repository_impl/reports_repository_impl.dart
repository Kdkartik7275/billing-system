import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/features/reports/data/data_source/reports_local_data_source.dart';
import 'package:billing_system/features/reports/data/data_source/reports_remote_data_source.dart';
import 'package:billing_system/features/reports/data/models/reports_model.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';
import 'package:billing_system/features/reports/domain/repository/reports_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportRemoteDataSource remoteDataSource;
  final ReportLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ReportsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<ReportEntity> generateReport(ReportEntity request) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final model = ReportModel.fromEntity(request);

      final result = await remoteDataSource.generateReport(model);

      await localDataSource.generateReport(result);

      return right(result.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ReportEntity> getReportById(String reportId) async {
    try {
      if (await connectionChecker.isConnected) {
        final remote = await remoteDataSource.getReportById(reportId);

        if (remote != null) {
          await localDataSource.updateReport(remote);
        }

        if (remote == null) {
          return left(FirebaseFailure(message: 'Report not found'));
        }

        return right(remote.toEntity());
      }

      final local = await localDataSource.getReportById(reportId);

      if (local == null) {
        return left(FirebaseFailure(message: 'Report not found'));
      }

      return right(local.toEntity());
    } catch (e) {
      try {
        final local = await localDataSource.getReportById(reportId);

        if (local == null) {
          return left(FirebaseFailure(message: 'Report not found'));
        }

        return right(local.toEntity());
      } catch (_) {
        return left(FirebaseFailure(message: e.toString()));
      }
    }
  }
}
