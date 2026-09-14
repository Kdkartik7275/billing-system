import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/layouts/reports_mobile_layout.dart';
import 'package:billing_system/features/reports/presentation/layouts/reports_tablet_layout.dart';
import 'package:billing_system/features/reports/presentation/layouts/reports_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ReportsController>()) {
      Get.put(
        ReportsController(
          generateReportUsecase: sl(),
          getReportByIdUsecase: sl(),
          getBillsByDateUsecase: sl(),
        ),
      );
    }

    return const AdaptiveLayout(
      mobile: ReportsMobileLayout(),
      tablet: ReportsTabletLayout(),
      desktop: ReportsWebLayout(),
    );
  }
}
