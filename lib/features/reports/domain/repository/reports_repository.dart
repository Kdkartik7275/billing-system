import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';

abstract interface class ReportsRepository {
  ResultFuture<ReportEntity> generateReport(ReportEntity request);
  ResultFuture<ReportEntity> getReportById(String reportId);
}
