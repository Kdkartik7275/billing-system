import 'package:billing_system/features/reports/data/models/reports_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class ReportLocalDataSource {
  Future<List<ReportModel>> getAllReports();

  Future<ReportModel?> getReportById(String id);

  Future<ReportModel?> getReportByBusinessDate(DateTime businessDate);

  Future<ReportModel> generateReport(ReportModel report);

  Future<ReportModel> updateReport(ReportModel report);

  Future<void> deleteReport(String id);

  Future<void> clear();
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  final Box<ReportModel> box;

  const ReportLocalDataSourceImpl({required this.box});

  @override
  Future<ReportModel> generateReport(ReportModel report) async {
    await box.put(report.id, report);
    return report;
  }

  @override
  Future<void> deleteReport(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<ReportModel>> getAllReports() async {
    return box.values.toList();
  }

  @override
  Future<ReportModel?> getReportById(String id) async {
    return box.get(id);
  }

  @override
  Future<ReportModel?> getReportByBusinessDate(DateTime businessDate) async {
    final startOfDay = DateTime(
      businessDate.year,
      businessDate.month,
      businessDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      return box.values.firstWhere(
        (report) =>
            !report.businessDate.isBefore(startOfDay) &&
            report.businessDate.isBefore(endOfDay),
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<ReportModel> updateReport(ReportModel report) async {
    await box.put(report.id, report);
    return report;
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
