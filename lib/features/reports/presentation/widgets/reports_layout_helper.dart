import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_action_button.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_cash_reconciliation_card.dart';
import 'package:flutter/material.dart';

Widget buildCashReconciliationSection(
  BuildContext context,
  ReportsController controller,
) {
  return ReportsCashReconciliationCard(controller: controller);
}

Widget buildReportActionButtonsSection(
  BuildContext context,
  ReportsController controller,
) {
  return ReportsActionButtons(controller: controller);
}