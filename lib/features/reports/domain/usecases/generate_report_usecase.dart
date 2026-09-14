import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';
import 'package:billing_system/features/reports/domain/repository/reports_repository.dart';

class GenerateReportUsecase
    implements UseCaseWithParams<ReportEntity, ReportEntity> {
  final ReportsRepository repository;

  GenerateReportUsecase({required this.repository});
  @override
  ResultFuture<ReportEntity> call(ReportEntity params) async {
    return await repository.generateReport(params);
  }
}
