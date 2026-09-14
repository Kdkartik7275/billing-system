import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';
import 'package:billing_system/features/reports/domain/repository/reports_repository.dart';

class GetReportByIdUsecase implements UseCaseWithParams<ReportEntity, String> {
  final ReportsRepository repository;

  GetReportByIdUsecase({required this.repository});

  @override
  ResultFuture<ReportEntity> call(String params) async {
    return await repository.getReportById(params);
  }
}
