import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/reports/data/models/reports_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ReportRemoteDataSource {
  Future<List<ReportModel>> getAllReports(String shopId);

  Future<ReportModel?> getReportById(String id);

  Future<ReportModel?> getReportByBusinessDate(DateTime businessDate);

  Future<ReportModel> generateReport(ReportModel report);

  Future<ReportModel> updateReport(ReportModel report);

  Future<void> deleteReport(String id);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseFirestore firestore;

  ReportRemoteDataSourceImpl({required this.firestore});

  static const _collection = 'reports';

  @override
  Future<ReportModel> generateReport(ReportModel report) async {
    try {
      await firestore
          .collection(_collection)
          .doc(report.id)
          .set(report.toJson());

      return report;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.generateReport',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.generateReport',
      );
      throw TFirebaseException('unknown').message;
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.deleteReport',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.deleteReport',
      );
      throw TFirebaseException('unknown').message;
    }
  }

  @override
  Future<List<ReportModel>> getAllReports(String shopId) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('shopId', isEqualTo: shopId)
          .orderBy('businessDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getAllReports',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getAllReports',
      );
      throw TFirebaseException('unknown').message;
    }
  }

  @override
  Future<ReportModel?> getReportById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return ReportModel.fromJson(doc.data()!);
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getReportById',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getReportById',
      );
      throw TFirebaseException('unknown').message;
    }
  }

  @override
  Future<ReportModel?> getReportByBusinessDate(DateTime businessDate) async {
    try {
      final startOfDay = DateTime(
        businessDate.year,
        businessDate.month,
        businessDate.day,
      );
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await firestore
          .collection(_collection)
          .where(
            'businessDate',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
          )
          .where('businessDate', isLessThan: endOfDay.toIso8601String())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return ReportModel.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getReportByBusinessDate',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.getReportByBusinessDate',
      );
      throw TFirebaseException('unknown').message;
    }
  }

  @override
  Future<ReportModel> updateReport(ReportModel report) async {
    try {
      await firestore
          .collection(_collection)
          .doc(report.id)
          .update(report.toJson());

      return report;
    } on FirebaseException catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.updateReport',
      );
      throw TFirebaseException(e.code).message;
    } catch (e, st) {
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'ReportRemoteDataSourceImpl.updateReport',
      );
      throw TFirebaseException('unknown').message;
    }
  }
}
